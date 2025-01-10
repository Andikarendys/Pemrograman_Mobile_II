<?php

namespace app\models;

use Illuminate\database\Eloquent\model;

class barang extends model
{
    protected $table = 'barang';
    protected $fillable = [
        'kodebarang',
        'namabarang',
        'hargabarang',
        'stokbarang',
        'gambarbarang',
    ];
}
?>