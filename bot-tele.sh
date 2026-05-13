#!/bin/bash

# ============================================
# Telegram Log Monitor v2.0
# Monitoring log file & kirim alert ke Telegram
# ============================================

# ========== KONFIGURASI ==========
LOG_FILE="/home/ghost666/log-tele.txt"
CHAT_ID=""           # <-- ISI: Chat ID Telegram
BOT_TOKEN=""         # <-- ISI: Bot Token Telegram
POLL_INTERVAL=2      # Interval cek log (detik)
MAX_MSG_LENGTH=4000  # Batas panjang pesan Telegram

# ========== VARIABEL STATE ==========
declare -i last_position=0
is_first_run=1

# ========== FUNGSI LOGGING ==========
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# ========== FUNGSI KIRIM TELEGRAM ==========
send_telegram() {
    local message="$1"
    
    # Validasi konfigurasi
    if [[ -z "$CHAT_ID" || -z "$BOT_TOKEN" ]]; then
        log "ERROR: CHAT_ID dan BOT_TOKEN harus diisi!"
        return 1
    fi
    
    # Truncate jika pesan terlalu panjang
    if [[ ${#message} -gt $MAX_MSG_LENGTH ]]; then
        message="${message:0:$((MAX_MSG_LENGTH - 100))}...[TRUNCATED]"
    fi
    
    # Kirim via curl
    local response
    response=$(curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
        --connect-timeout 10 \
        --max-time 30 \
        -d chat_id="${CHAT_ID}" \
        -d text="${message}" \
        -d parse_mode="HTML" 2>&1)
    
    # Cek hasil
    if [[ $? -ne 0 ]]; then
        log "ERROR: Curl gagal - $response"
        return 1
    fi
    
    if [[ "$response" == *"\"ok\":false"* ]]; then
        log "ERROR: Telegram API - $response"
        return 1
    fi
    
    log "Alert terkirim"
    return 0
}

# ========== FUNGSI FORMAT PESAN ==========
format_message() {
    local log_content="$1"
    local server_time=$(date '+%d %b %Y %H:%M:%S')
    
    # Escape karakter khusus HTML
    log_content=$(echo "$log_content" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
    
    cat <<EOF
<b>SECURITY ALERT</b>

Halo Sayangku Admin Terdeteksi penyerangan pada server!

<b>Waktu Server:</b> ${server_time}

<b>Log Terbaru:</b>
<pre>${log_content}</pre>

Silakan cek server segera!
EOF
}

# ========== FUNGSI PROSES LOG BARU ==========
process_logs() {
    # Cek file ada
    if [[ ! -f "$LOG_FILE" ]]; then
        log "WARNING: File log tidak ditemukan: $LOG_FILE"
        sleep 5
        return 1
    fi
    
    # Dapatkan ukuran file
    local current_size
    current_size=$(stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)
    
    # First run: set posisi awal, skip kirim
    if [[ $is_first_run -eq 1 ]]; then
        last_position=$current_size
        is_first_run=0
        log "Inisialisasi: memantau dari byte ke-$last_position"
        return 0
    fi
    
    # Deteksi log rotation (file di-truncate/rotate)
    if [[ $current_size -lt $last_position ]]; then
        log "File log di-rotate, reset posisi"
        last_position=0
    fi
    
    # Cek ada data baru
    if [[ $current_size -gt $last_position ]]; then
        local new_logs
        new_logs=$(tail -c +$((last_position + 1)) "$LOG_FILE" 2>/dev/null)
        
        if [[ -n "$new_logs" ]]; then
            local message
            message=$(format_message "$new_logs")
            send_telegram "$message"
        fi
        
        last_position=$current_size
    fi
}

# ========== CLEANUP ON EXIT ==========
cleanup() {
    log "Script dihentikan"
    exit 0
}
trap cleanup INT TERM

# ========== MAIN ==========
log "========================================"
log "Telegram Log Monitor v2.0 dimulai"
log "File: $LOG_FILE"
log "========================================"

while true; do
    process_logs
    sleep "$POLL_INTERVAL"
done