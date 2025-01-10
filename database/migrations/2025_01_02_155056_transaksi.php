<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('transaksi', function (Blueprint $table) {
            $table->id();
            $table->string('kodetransaksi');
            $table->string('namapelanggan');
            $table->string('nohp');
            $table->string('namabarang');
            $table->integer('hargabarang');
            $table->integer('jumlahbarang');
            $table->integer('totalharga');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
    }
};