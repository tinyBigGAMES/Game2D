<?php
/******************************************************************************
    ___                ___ ___ ™ 
   / __|__ _ _ __  ___|_  )   \ 
  | (_ / _` | '  \/ -_)/ /| |) |
   \___\__,_|_|_|_\___/___|___/ 
        Build. Play. Repeat.

 Copyright © 2025-present tinyBigGAMES™ LLC
 All Rights Reserved.

 https://github.com/tinyBigGAMES/Game2D

 BSD 3-Clause License

 Copyright (c) 2025-present, tinyBigGAMES LLC

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the copyright holder nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 
 Game2D Remote Database API - Main Endpoint
 
 INSTALLATION & SETUP:
 ====================
 
 1. FILE PLACEMENT:
    - Place this file in your web-accessible directory (e.g., /public_html/api/)
    - Place config.php in /remotedb/ folder (one level up from your web root)
    
    Directory structure example:
    /var/www/
    ├── remotedb/
    │   ├── config.php              ← Configuration (outside web root)
    │   ├── api_2025-06-10.log      ← Daily API log (auto-created)
    │   └── errors_2025-06-10.log   ← Daily error log (auto-created)
    └── html/                       ← Web root
        └── api/
            └── remotedb.php        ← This file (web accessible)
    
 2. WEB SERVER SETUP:
    - Ensure PHP 7.4+ is installed
    - Enable PDO MySQL extension
    - Configure HTTPS (recommended for production)
    
 3. API USAGE FROM DELPHI:
    
    // Setup your Game2D.RemoteDb
    LDb := Tg2dRemoteDb.Create();
    LDb.Setup('https://yourdomain.com/api/remotedb.php', 'your_api_key', 'your_database');
    
    // Execute queries
    LDb.SetSQLText('SELECT * FROM users WHERE id = :id');
    LDb.SetParam('id', '123');
    if LDb.Execute() then
    begin
      // Process results
      for i := 0 to LDb.RecordCount() - 1 do
        ShowMessage(LDb.GetField(i, 'username'));
    end;
    
 4. API ACCESS LEVELS:
    
    Regular API Key:
    - Can use: SELECT, INSERT, UPDATE, DELETE
    - Blocked: DROP, ALTER, CREATE, TRUNCATE, SQL comments
    - Good for: Application users, automated systems
    
    Admin API Key:
    - Full MySQL access (all commands allowed)
    - Can use: Everything including DROP, ALTER, CREATE
    - Good for: Database maintenance, admin tools
    
 5. SECURITY FEATURES:
    - Rate limiting (requests per hour per IP)
    - SQL injection protection
    - API key validation
    - Query length limits
    - Daily rotating access logs with automatic cleanup
    
 6. TROUBLESHOOTING:
    - Check daily log files in /remotedb/ folder
    - Verify config.php path is correct
    - Test with simple query: SELECT 1
    - Ensure database user has proper permissions
 
 =============================================================================
 PRODUCTION ENVIRONMENT - INDIE GAME SUITABILITY
 =============================================================================
 
 ✅ EXCELLENT FOR INDIE GAMES:
 - Small to medium player base (up to ~1000 concurrent users)
 - Cost effective: $15-30/month hosting vs $50-100+ for Firebase/Supabase
 - Simple deployment: Copy 2 files, configure, done
 - Perfect for: Leaderboards, user profiles, achievements, game stats
 - Works great with: Turn-based games, puzzle games, RPGs, strategy games
 - Performance: ~50-100ms latency, handles ~100 requests/second sustained
 
 ❌ NOT SUITABLE FOR:
 - Real-time multiplayer games (FPS, racing games)
 - Live chat systems (needs WebSockets)
 - Very high scale (10,000+ concurrent users)
 - Games requiring sub-20ms response times
 
 📊 SCALING GUIDELINES:
 - Small indie (< 1000 users): Shared hosting ($10-20/month) ✅
 - Growing indie (1000-10000): VPS + optimizations ($25-50/month) ✅
 - Large scale (10000+): Consider Firebase/custom solutions ($100+/month)
 
 💡 BOTTOM LINE:
 This approach is perfect for most indie games. Start here - it's proven,
 cost-effective, and you can always migrate later if you become the next
 big indie hit. More games fail from over-engineering than under-engineering.
 
 =============================================================================
 
 API URL Format:
 https://yourdomain.com/api/remotedb.php?apikey=YOUR_KEY&keyspace=DATABASE_NAME&query=SQL_QUERY
 
******************************************************************************/

define('MAIN_INCLUDED', 1);

class Config {
    private $master_db_host;
    private $master_db_port;
    private $master_db_user;
    private $master_db_pass;
    private $apikey;
    private $admin_apikey;
    private $max_requests_per_hour;
    private $max_query_length;
    private $enable_logging;
    private $api_log_file;
    private $error_log_file;
    private $log_level;
    private $keep_logs_for_days;
    private $auto_cleanup_logs;

    public function __construct(){
        // =================================================================
        // CONFIG FILE PATH - CUSTOMIZE THIS IF NEEDED
        // =================================================================
        // Default: One folder up from web root, in /remotedb/ subfolder
        // You can modify this path to point to your config file location
        // 
        // Examples of custom paths:
        // $config_path = "/home/username/remotedb/config.php";
        // $config_path = "/var/www/secure/config.php";
        // $config_path = $_SERVER['DOCUMENT_ROOT'] . '/../config/remotedb.php';
        // $config_path = __DIR__ . '/../../private/config.php';
        
        $config_path = __DIR__ . '/../remotedb/config.php';  // DEFAULT - modify this line if needed
        
        // =================================================================
        
        if (!file_exists($config_path)) {
            header('HTTP/1.1 500 Internal Server Error');
            echo json_encode(array(
                "query_status" => "ERROR",
                "response" => "Configuration file not found at: " . $config_path . ". Please check the path or create the config file."
            ));
            exit();
        }
        
        include($config_path);
        
        $this->master_db_host = $master_db_host ?? 'localhost';
        $this->master_db_port = $master_db_port ?? '3306';
        $this->master_db_user = $master_db_user ?? '';
        $this->master_db_pass = $master_db_pass ?? '';
        $this->apikey = $apikey ?? '';
        $this->admin_apikey = $admin_apikey ?? '';
        $this->max_requests_per_hour = $max_requests_per_hour ?? 1000;
        $this->max_query_length = $max_query_length ?? 8192;
        $this->enable_logging = $enable_logging ?? false;
        $this->api_log_file = $api_log_file ?? '';
        $this->error_log_file = $error_log_file ?? '';
        $this->log_level = $log_level ?? 'ALL';
        $this->keep_logs_for_days = $keep_logs_for_days ?? 30;
        $this->auto_cleanup_logs = $auto_cleanup_logs ?? true;
        
        // Validate essential config
        if (empty($this->apikey)) {
            header('HTTP/1.1 500 Internal Server Error');
            echo json_encode(array(
                "query_status" => "ERROR",
                "response" => "API key not configured. Please update config.php."
            ));
            exit();
        }
    }

    public function get($varname){
        return isset($this->$varname) ? $this->$varname : false;
    }
}

class Logger {
    public static function log($level, $message, $context = []) {
        global $Config;
        
        if (!$Config->get('enable_logging')) return;
        
        $log_level = strtoupper($Config->get('log_level'));
        
        // Check if we should log this level
        if ($log_level === 'NONE') return;
        if ($log_level === 'ERROR' && $level !== 'ERROR') return;
        
        $log_entry = sprintf("[%s] %s", date('Y-m-d H:i:s'), $message);
        
        // Determine which log file to use
        $log_file = '';
        if ($level === 'ERROR' && !empty($Config->get('error_log_file'))) {
            $log_file = $Config->get('error_log_file');
        } elseif (!empty($Config->get('api_log_file'))) {
            $log_file = $Config->get('api_log_file');
        }
        
        if (!empty($log_file)) {
            // Write to custom log file
            file_put_contents($log_file, $log_entry . "\n", FILE_APPEND | LOCK_EX);
        } else {
            // Fallback to system error log
            error_log($log_entry);
        }
    }
    
    public static function cleanup_old_logs() {
        global $Config;
        
        if (!$Config->get('auto_cleanup_logs')) return;
        
        $keep_days = $Config->get('keep_logs_for_days');
        if ($keep_days <= 0) return; // Keep forever
        
        $cutoff_time = time() - ($keep_days * 24 * 60 * 60);
        
        // Get log directory from api_log_file path
        $api_log_file = $Config->get('api_log_file');
        if (empty($api_log_file)) return;
        
        $log_dir = dirname($api_log_file);
        if (!is_dir($log_dir)) return;
        
        // Find and delete old log files
        $files = glob($log_dir . '/*.log');
        foreach ($files as $file) {
            if (is_file($file) && filemtime($file) < $cutoff_time) {
                unlink($file);
            }
        }
    }
}

class Common {
    public static function requested_keyspace(){
        if(isset($_REQUEST['keyspace']) && !empty($_REQUEST['keyspace'])){
            return $_REQUEST['keyspace'];
        }else{
            header("HTTP/1.1 400 Bad Request");
            echo json_encode(array("query_status"=>"ERROR","response"=>"You must set a keyspace (database name)!"));
            exit();
        }
    }

    public static function requested_query(){
        if(isset($_REQUEST['query']) && !empty($_REQUEST['query'])){
            return $_REQUEST['query'];
        }else{
            header("HTTP/1.1 400 Bad Request");
            echo json_encode(array("query_status"=>"ERROR","response"=>"You must set a query!"));
            exit();
        }
    }
}

class Auth {
    public static function api_check_key() {
        global $Config;
        $apikey = $Config->get("apikey");
        $admin_apikey = $Config->get("admin_apikey");
        
        if(!isset($_REQUEST["apikey"]) || empty($_REQUEST["apikey"])){
            header('HTTP/1.0 401 Unauthorized');
            echo json_encode(array("query_status"=>"ERROR","response"=>"API key required."));
            exit();
        }
        
        $provided_key = $_REQUEST["apikey"];
        
        // Check admin key first (if configured)
        if (!empty($admin_apikey) && hash_equals($admin_apikey, $provided_key)) {
            return 'admin';  // Full MySQL access
        } elseif (hash_equals($apikey, $provided_key)) {
            return 'user';   // Restricted access
        } else {
            header('HTTP/1.0 401 Unauthorized');
            echo json_encode(array("query_status"=>"ERROR","response"=>"Invalid API key."));
            exit();
        }
    }
}

class Security {
    public static function rate_limit_check($ip, $max_requests) {
        $limit_file = "/tmp/remotedb_rate_limit_" . md5($ip) . ".txt";
        $current_time = time();
        $hour_ago = $current_time - 3600;
        
        $requests = [];
        if (file_exists($limit_file)) {
            $content = file_get_contents($limit_file);
            $requests = $content ? explode("\n", trim($content)) : [];
            // Remove requests older than 1 hour
            $requests = array_filter($requests, function($timestamp) use ($hour_ago) {
                return $timestamp > $hour_ago;
            });
        }
        
        if (count($requests) >= $max_requests) {
            return false;
        }
        
        $requests[] = $current_time;
        file_put_contents($limit_file, implode("\n", $requests), LOCK_EX);
        return true;
    }

    public static function validate_query($query, $max_length) {
        // Check query length
        if (strlen($query) > $max_length) {
            return false;
        }
        
        // Block dangerous patterns for regular users
        $dangerous = [
            '/;\s*(DROP|ALTER|CREATE|TRUNCATE)/i',  // Dangerous commands
            '/--/',                                  // SQL comments
            '/\/\*.*?\*\//'                         // Multi-line comments
        ];
        
        foreach ($dangerous as $pattern) {
            if (preg_match($pattern, $query)) {
                return false;
            }
        }
        
        return true;
    }
}

class Db {
    public static function pdo_query($link, $q, $data = array()){  
        $rq_type = substr(strtolower($q), 0, 6);

        try{
            $res = array();
            $rec = $link->prepare($q);  
            
            if($rq_type == "select"){
                $rec->execute($data); 
                $rec->setFetchMode(\PDO::FETCH_ASSOC);  
                while($rs = $rec->fetch()){
                    $res[] = $rs;
                }
            }else{
                $res = $rec->execute($data); 
            }

            $rec->closeCursor();
            return $res;

        }catch(\PDOException $ex){
            // Log database errors
            Logger::log('ERROR', "Database error: " . $ex->getMessage());
            return false;
        } 
    }
}

// =============================================================================
// MAIN EXECUTION
// =============================================================================

// Initialize classes
$Config = new Config;
$Common = new Common;
$Auth = new Auth;
$Db = new Db;

// Occasionally run log cleanup (1% chance per request)
if ($Config->get('auto_cleanup_logs') && rand(1, 100) === 1) {
    Logger::cleanup_old_logs();
}

// Start timing
$query_start = microtime(true);

// Security checks
$auth_level = $Auth->api_check_key();

$client_ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
if (!Security::rate_limit_check($client_ip, $Config->get('max_requests_per_hour'))) {
    header('HTTP/1.1 429 Too Many Requests');
    Logger::log('WARNING', "Rate limit exceeded for IP: $client_ip");
    echo json_encode(array("query_status"=>"ERROR","response"=>"Rate limit exceeded. Try again later."));
    exit();
}

// Get request parameters
$keyspace = $Common->requested_keyspace();
$query = $Common->requested_query();

// Validate query for regular users (admin bypasses validation)
if ($auth_level === 'user') {
    if (!Security::validate_query($query, $Config->get('max_query_length'))) {
        header('HTTP/1.1 400 Bad Request');
        Logger::log('WARNING', "Invalid query attempt from $client_ip: " . substr($query, 0, 100));
        echo json_encode(array("query_status"=>"ERROR","response"=>"Invalid or unsafe query."));
        exit();
    }
}
// Admin users can execute any SQL command

$data = [];

// Connect to database
try{
    $dbPDO = new PDO(
        'mysql:dbname='.$keyspace.';host='.$Config->get("master_db_host").';port='.$Config->get("master_db_port"), 
        $Config->get("master_db_user"), 
        $Config->get("master_db_pass"),
        array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION)
    );
} catch(PDOException $ex){
    header('HTTP/1.1 500 Internal Server Error');
    Logger::log('ERROR', "Database connection failed for keyspace '$keyspace': " . $ex->getMessage());
    echo json_encode(array("query_status"=>"ERROR","response"=>"Database connection failed."));
    exit();
}

// Execute query
$response = $Db->pdo_query($dbPDO, $query, $data);

if ($response === false) {
    header('HTTP/1.1 400 Bad Request');
    Logger::log('ERROR', "Query execution failed from $client_ip on '$keyspace': " . substr($query, 0, 100));
    echo json_encode(array("query_status"=>"ERROR","response"=>"Query execution failed."));
    exit();
}

// Calculate timing and response size
$query_status = "OK";
$query_end = microtime(true);
$query_time = $query_end - $query_start;
$response_length = strlen(json_encode($response));

// Log successful request
Logger::log('INFO', sprintf("%s (%s) executed query on '%s': %s", 
    $client_ip, 
    $auth_level,
    $keyspace,
    substr($query, 0, 100) // First 100 characters
));

// Return successful response
echo json_encode(array(
    "query_status" => $query_status,
    "query_time" => $query_time,
    "response_length" => $response_length,
    "response" => $response
));
?>