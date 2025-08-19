#!/bin/bash

# --- Fungsi untuk menampilkan teks berwarna hijau ---
green_text() {
  echo -e "\e[32m$1\e[0m" # \e[32m untuk hijau, \e[0m untuk reset warna
}

# --- Fungsi untuk menampilkan judul berbingkai ---
display_framed_title() {
  local title="$1"
  local len=${#title}
  local border_length=$((len + 4)) # Panjang border disesuaikan dengan judul + spasi

  green_text "" # Baris kosong di atas untuk kerapian
  green_text "$(printf '─%.0s' $(seq 1 $border_length))" # Garis atas
  green_text "│  $title  │" # Judul di tengah
  green_text "$(printf '─%.0s' $(seq 1 $border_length))" # Garis bawah
  green_text "" # Baris kosong di bawah untuk kerapian
}
# =========================================================
# =================================="
SUDO_PASSWORD="ArcheR212e" # <--- GANTI INI DENGAN PASSWORD ASLI JIKA TETAP INGIN COBA!
# =========================================================

clear # Bersihkan layar

display_framed_title "MAINTENANCE SISTEM APT"

green_text "Memulai proses pembersihan sistem..."
green_text "----------------------------------------------------"

# Menyalurkan password ke sudo -S untuk perintah apt clean, autoclean, autoremove, dan update
echo "$SUDO_PASSWORD" | sudo -S bash -c "apt clean && apt autoclean && apt autoremove -y && apt update"

green_text "----------------------------------------------------"
green_text "Pembersihan sistem selesai dan daftar paket telah diperbarui."
sleep 1

# --- Menu Opsi Upgrade ---
while true; do
  clear

      NUM_UPGRADABLE=$(echo "$SUDO_PASSWORD" | sudo -S apt list --upgradable 2>/dev/null | grep -c '\[upgradable from:')

      if [ "$NUM_UPGRADABLE" -gt 0 ]; then
        display_framed_title "Terdapat $NUM_UPGRADABLE paket yang perlu diperbarui"
        green_text "Daftar paket yang akan di-upgrade:"
        echo "$SUDO_PASSWORD" | sudo -S apt list --upgradable # Menampilkan daftar yang bisa di-upgrade
        green_text ""
      else
        display_framed_title "BELUM ADA PAKET UNTUK DIPERBARUI!"
        green_text "Sistem Anda sudah mutakhir atau tidak ada paket yang perlu di-upgrade saat ini."
      fi
      sleep 2 # Beri waktu pengguna membaca


  display_framed_title "LANJUTKAN DENGAN UPGRADE?"

  green_text "Pilih opsi selanjutnya:"
  green_text "1. Lanjutkan 'apt upgrade' (memperbarui paket yang ada)"
  green_text "2. Lanjutkan 'apt full-upgrade' (memperbarui paket dan menangani perubahan dependensi)"
  green_text "3. Keluar dari program"
  green_text ""
  green_text "Masukkan pilihan Anda (1/2/3): "
  read upgrade_choice

  case $upgrade_choice in
    1)
      clear

      # Mendapatkan jumlah paket yang bisa di-upgrade
      # Menggunakan apt list --upgradable | grep -c '\[upgradable from:'
      # untuk menghitung baris yang menandakan paket upgradable
      # dan mengabaikan header "Listing..."
      NUM_UPGRADABLE=$(echo "$SUDO_PASSWORD" | sudo -S apt list --upgradable 2>/dev/null | grep -c '\[upgradable from:')

      if [ "$NUM_UPGRADABLE" -gt 0 ]; then
        display_framed_title "Terdapat $NUM_UPGRADABLE paket yang perlu diperbarui"
        green_text "Daftar paket yang akan di-upgrade:"
        echo "$SUDO_PASSWORD" | sudo -S apt list --upgradable # Menampilkan daftar yang bisa di-upgrade
        read confirm_upgrade

      else
        display_framed_title "BELUM ADA PAKET UNTUK DIPERBARUI!"
        green_text "Sistem Anda sudah mutakhir atau tidak ada paket yang perlu di-upgrade saat ini."
      fi
      sleep 2 # Beri waktu pengguna membaca
      exit 0 # Keluar otomatis setelah selesai
      ;;
    2)
      clear
      display_framed_title "PEMBARUAN LENGKAP (FULL-UPGRADE)"
      green_text "Memulai 'apt full-upgrade'..."
      echo "$SUDO_PASSWORD" | sudo -S apt full-upgrade -y # Melakukan full-upgrade
      green_text "----------------------------------------------------"
      green_text "Proses 'apt full-upgrade' selesai."
      sleep 2 # Beri waktu pengguna membaca
      exit 0 # Keluar otomatis setelah selesai
      ;;
    3)
      green_text "Terima kasih telah menggunakan program maintenance. Sampai jumpa!"
      exit 0 # Keluar dari script
      ;;
    *)
      green_text "\e[31mPilihan tidak valid. Silakan coba lagi.\e[0m"
      sleep 2
      ;;
  esac
done
