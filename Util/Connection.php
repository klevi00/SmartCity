<?php

namespace Util;
use PDO;

require_once '../conf/config.php';

class Connection
{
    private static PDO $pdo;

    private function __construct() {}

    public static function getInstance(): PDO
    {
        if (!isset(self::$pdo)) {
            $DSN = 'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=' . DB_CHAR;
            self::$pdo = new PDO($DSN, DB_USER, DB_PASSWORD, [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            ]);
        }
        return self::$pdo;
    }
}
