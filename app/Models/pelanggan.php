<?php

namespace app\models;

use Illuminate\database\Eloquent\model;

class pelanggan extends model
{
    protected $table = 'pelanggan';
    protected $fillable = [
        'namapelanggan',
        'nohp',
        'email',
    ];
}
?>