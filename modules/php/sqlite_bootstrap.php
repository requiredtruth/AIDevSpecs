<?php
declare(strict_types=1);

/** Open SQLite with safe local defaults. */
function open_sqlite_database(string $databasePath, int $busyTimeoutMs = 5000): PDO
{
    if ($busyTimeoutMs < 100 || $busyTimeoutMs > 60000) {
        throw new InvalidArgumentException('busy timeout must be between 100 and 60000 milliseconds');
    }
    $directory = dirname($databasePath);
    if (!is_dir($directory) && !mkdir($directory, 0750, true) && !is_dir($directory)) {
        throw new RuntimeException('unable to create database directory');
    }
    $pdo = new PDO('sqlite:' . $databasePath, null, null, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);
    $pdo->exec('PRAGMA foreign_keys = ON');
    $pdo->exec('PRAGMA busy_timeout = ' . $busyTimeoutMs);
    $pdo->exec('PRAGMA journal_mode = WAL');
    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS schema_migrations (' .
        'version INTEGER PRIMARY KEY CHECK(version > 0), ' .
        'name TEXT NOT NULL, applied_utc TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP)'
    );
    return $pdo;
}

/**
 * Apply ordered callable migrations.
 *
 * Each item is: ['version' => positive int, 'name' => string, 'apply' => callable(PDO): void].
 */
function apply_sqlite_migrations(PDO $pdo, array $migrations): int
{
    foreach ($migrations as $index => $migration) {
        $expected = $index + 1;
        if (($migration['version'] ?? null) !== $expected || !is_string($migration['name'] ?? null) || !is_callable($migration['apply'] ?? null)) {
            throw new InvalidArgumentException('migrations must be contiguous, named, and callable');
        }
    }
    $applied = array_map('intval', $pdo->query('SELECT version FROM schema_migrations ORDER BY version')->fetchAll(PDO::FETCH_COLUMN));
    $current = $applied === [] ? 0 : $applied[array_key_last($applied)];
    if ($applied !== [] && $applied !== range(1, $current)) {
        throw new RuntimeException('database migration history is not contiguous');
    }
    if ($current > count($migrations)) {
        throw new RuntimeException('database schema is newer than this migration set');
    }
    foreach (array_slice($migrations, $current) as $migration) {
        $pdo->exec('BEGIN IMMEDIATE');
        try {
            $migration['apply']($pdo);
            $statement = $pdo->prepare('INSERT INTO schema_migrations(version, name) VALUES (:version, :name)');
            $statement->execute([':version' => $migration['version'], ':name' => $migration['name']]);
            $pdo->commit();
        } catch (Throwable $error) {
            if ($pdo->inTransaction()) {
                $pdo->rollBack();
            }
            throw $error;
        }
        $current = $migration['version'];
    }
    return $current;
}
