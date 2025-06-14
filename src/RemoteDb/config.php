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
  
 Game2D Remote Database API - Configuration File
 
 SETUP INSTRUCTIONS:
 ===================
 
 1. DIRECTORY STRUCTURE:
    Your web directory should look like this:
    
    /your-website/
    ├── remotedb/                    ← Place this config.php file here
    │   ├── config.php               ← THIS FILE
    │   ├── api_2025-06-10.log       ← Daily API log (auto-created)
    │   ├── api_2025-06-09.log       ← Previous day log
    │   ├── errors_2025-06-10.log    ← Daily error log (auto-created)
    │   └── errors_2025-06-09.log    ← Previous day errors
    └── public_html/ (or www/)       ← Your web root
        └── api/                     ← Place index.php here
            └── remotedb.php         ← The API endpoint
    
    Example full paths:
    /var/www/remotedb/config.php              ← Config (outside web root)
    /var/www/remotedb/api_2025-06-10.log      ← Today's API log (outside web root)
    /var/www/html/api/remotedb.php            ← API (inside web root)
    
 2. SECURITY:
    - The /remotedb/ folder should be OUTSIDE your web root
    - This prevents direct access to your database credentials and logs
    - Web users can access /api/remotedb.php but NOT /remotedb/ files
    
 3. API KEYS:
    - Generate strong API keys (32+ characters)
    - Use different keys for regular users vs admin access
    - Recommended: https://www.grc.com/passwords.htm
    
 4. DATABASE USER:
    - Create a dedicated MySQL user for this API
    - Grant only necessary permissions (SELECT, INSERT, UPDATE, DELETE)
    - Do NOT use your root MySQL user
    
 5. USAGE:
    API URL format: https://yourdomain.com/api/remotedb.php?apikey=KEY&keyspace=DATABASE&query=SQL
    
    Examples:
    - Regular user: apikey=user_key_123 (limited SQL)
    - Admin user:   apikey=admin_key_456 (full MySQL access)

 6. ACCESSING LOGS:
    Logs are automatically rotated daily and old logs are cleaned up.
    
    LOG FILES LOCATION:
    - Today's API log: /path/to/remotedb/api_2025-06-10.log
    - Today's error log: /path/to/remotedb/errors_2025-06-10.log
    - Previous days: api_2025-06-09.log, api_2025-06-08.log, etc.
    
    VIEWING LOGS:
    - Current day: tail -f /path/to/remotedb/api_$(date '+%Y-%m-%d').log
    - All recent: tail -f /path/to/remotedb/api_*.log
    - Count today's requests: wc -l /path/to/remotedb/api_$(date '+%Y-%m-%d').log
    - Search for errors: grep "ERROR" /path/to/remotedb/errors_*.log
    
    LOG MANAGEMENT:
    - New log file created each day automatically
    - Old logs deleted after 30 days (configurable)
    - Log level can be changed (ALL, ERROR, NONE)
    
    LOG FORMAT EXAMPLE:
    [2025-06-10 14:30:15] 192.168.1.100 (user) executed query on 'game_db': SELECT * FROM scores
    
******************************************************************************/

if(!defined('MAIN_INCLUDED'))
    exit("Access denied! This file cannot be accessed directly.");

// =============================================================================
// DATABASE CONFIGURATION
// =============================================================================
// Your MySQL server details
$master_db_host = "localhost";              // MySQL host (usually localhost)
$master_db_port = "3306";                   // MySQL port (usually 3306)
$master_db_user = "your_db_username";       // MySQL username (NOT root!)
$master_db_pass = "your_secure_password";   // MySQL password

// =============================================================================
// API SECURITY KEYS
// =============================================================================
// Regular user API key - limited SQL access (no DROP, ALTER, etc.)
$apikey = "your_regular_user_api_key_here_32_chars_minimum";

// Admin API key - full MySQL access (can use DROP, ALTER, CREATE, etc.)
// Leave empty to disable admin access
$admin_apikey = "your_admin_api_key_here_must_be_different_from_regular";

// =============================================================================
// SECURITY SETTINGS
// =============================================================================
$max_requests_per_hour = 1000;              // Rate limit per IP address
$max_query_length = 8192;                   // Maximum SQL query length
$enable_logging = true;                     // Log API usage (recommended)

// =============================================================================
// LOGGING CONFIGURATION (RECOMMENDED SETTINGS)
// =============================================================================
// Create daily log files (automatically rotates daily)
$api_log_file = __DIR__ . "/api_" . date('Y-m-d') . ".log";       // api_2025-06-10.log
$error_log_file = __DIR__ . "/errors_" . date('Y-m-d') . ".log";  // errors_2025-06-10.log

// Log management settings
$log_level = 'ALL';                          // 'ALL' = log everything, 'ERROR' = errors only, 'NONE' = disabled
$keep_logs_for_days = 30;                    // Auto-delete logs older than 30 days (0 = keep forever)
$auto_cleanup_logs = true;                   // Enable automatic cleanup of old logs

// =============================================================================
// SETUP CHECKLIST - Remove this section after setup
// =============================================================================
/*
 TODO - Configure the following before using:
 
 [ ] 1. Update database credentials above
 [ ] 2. Generate strong API keys (32+ characters each)
 [ ] 3. Create MySQL user with limited permissions
 [ ] 4. Test connection with your Delphi application
 [ ] 5. Enable HTTPS on your web server (strongly recommended)
 [ ] 6. Remove this checklist section
 [ ] 7. Verify /remotedb/ folder is outside web root
 [ ] 8. Test API call and check that daily log file is created
 [ ] 9. After testing, consider changing log_level to 'ERROR' for production
 
 For support: Check api_YYYY-MM-DD.log and errors_YYYY-MM-DD.log files in /remotedb/ folder.
 
 PRODUCTION TIPS:
 - Set log_level = 'ERROR' after initial testing to reduce log size
 - Monitor disk space occasionally (though 30-day cleanup should handle this)
 - Check logs if you experience any API issues
*/
?>