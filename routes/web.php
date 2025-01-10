<?php

/** @var \Laravel\Lumen\Routing\Router $router */

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

$router->get('/', function () use ($router) {
    return $router->app->version();
});


$router->group(['prefix' => 'barang'], function () use ($router) {
    $router->get('/', 'barangcontroller@read');
    $router->post('/simpan', 'barangcontroller@add');
    $router->put('/ubah/{id}', 'barangcontroller@update');
    $router->delete('/hapus/{id}', 'barangcontroller@delete');
});


$router->group(['prefix' => 'pelanggan'], function () use ($router) {
    $router->get('/', 'pelanggancontroller@read');
    $router->post('/simpan', 'pelanggancontroller@add');
    $router->put('/ubah/{id}', 'pelanggancontroller@update');
    $router->delete('/hapus/{id}', 'pelanggancontroller@delete');
});


$router->group(['prefix' => 'transaksi'], function () use ($router) {
    $router->get('/', 'transaksicontroller@read');
    $router->post('/simpan', 'transaksicontroller@add');
    $router->put('/ubah/{id}', 'transaksicontroller@update');
    $router->delete('/hapus/{id}', 'transaksicontroller@delete');
});
