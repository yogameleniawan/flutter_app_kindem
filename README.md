# Kindem Flutter Application

## Daftar Isi
- [Kindem Flutter Application](#kindem-flutter-application)
  - [Daftar Isi](#daftar-isi)
  - [Setup pertama kali](#setup-pertama-kali)
  - [Requirements](#requirements)
  - [Resources](#resources)
  - [Copyright](#copyright)


## Setup pertama kali
1. Clone repository
	```bash
	# Clone dengan SSH
	git clone git@github.com/yogameleniawan/kindem_rest_api.git
	# Clone dengan HTTPS
	git clone https://github.com/yogameleniawan/kindem_rest_api.git
	```
2. Install laravel dan php dependency
	```
	composer install
	```
3. Setup konfigurasi  
Buat file `.env` di root project dan copy isi file `.env.example` ke `.env`  
Ubah konfigurasi sesuai keperluan. Pastikan `APP_URL_BASE` sudah benar
	```bash
	# Unix/Linux/Windows Powershell
	cp .env.example .env
	# Windows CMD
	copy .env.example .env
	```
4. Generate application key
	```
	php artisan key:generate
	```
5. Migrasi database  
Pastikan konfigurasi database di `.env` sudah benar
	```
	php artisan migrate
	```
6. Seed database _[opsional]_
	```
	php artisan db:seed
	```
7. Install node dependency
	```
	npm install
	```
8. Running Aplikasi
    Jalankan 2 perintah dibawah ini :
    ```
	php artisan serve
    ```
    
## Requirements
- Android OS >= 7.0 (Nougat)
- Flutter SDK Version >= 3.0 (https://docs.flutter.dev/get-started/install)

## Resources

Design UI : https://www.figma.com/file/g6flnOGXIs3YX7WShk5Kyc/KINDEM-MOBILE-APP-DESIGN

## Copyright
2022 [Abdul Rahman Saleh](https://www.linkedin.com/in/abdul-rahman-saleh-714120217/) & [Yoga Meleniawan Pamungkas](https://www.linked.in/id/yogameleniawan)
