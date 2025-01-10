<?php

namespace app\models;

use Illuminate\database\Eloquent\model;

class transaksi extends model
{
    protected $table = 'transaksi';
    protected $fillable = [
        'kodetransaksi',
        'namapelanggan',
        'nohp',
        'namabarang',
        'hargabarang',
        'jumlahbarang',
        'totalharga',
    ];
}
?>