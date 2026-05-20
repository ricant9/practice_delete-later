<?php

use App\Kernel;
use Symfony\Component\Dotenv\Dotenv;

require_once dirname(__DIR__).'/vendor/autoload_runtime.php';

if (!isset($_SERVER['APP_ENV']) && !isset($_ENV['APP_ENV'])) {
    $dotenvPath = dirname(__DIR__).'/.env';
    if (file_exists($dotenvPath)) {
        (new Dotenv())->loadEnv($dotenvPath);
    }
}

return static function (array $context) {
    $env = $context['APP_ENV'] ?? $_SERVER['APP_ENV'] ?? $_ENV['APP_ENV'] ?? 'prod';
    $debug = filter_var($context['APP_DEBUG'] ?? $_SERVER['APP_DEBUG'] ?? $_ENV['APP_DEBUG'] ?? false, FILTER_VALIDATE_BOOLEAN);

    return new Kernel($env, $debug);
};
