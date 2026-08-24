<?php
declare(strict_types=1);

/** Emit one JSON response without exposing exception traces or configuration. */
function send_json(int $status, array $payload): never
{
    if ($status < 100 || $status > 599) {
        throw new InvalidArgumentException('HTTP status is out of range');
    }
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    header('Cache-Control: no-store');
    echo json_encode($payload, JSON_THROW_ON_ERROR | JSON_UNESCAPED_SLASHES) . "\n";
    exit;
}

/** Emit a bounded public error. Log private diagnostics separately after redaction. */
function send_public_error(int $status, string $code, string $message): never
{
    send_json($status, [
        'ok' => false,
        'error' => ['code' => $code, 'message' => $message],
    ]);
}
