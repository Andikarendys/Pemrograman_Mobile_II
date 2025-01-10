<?php
namespace App\Http\Controllers;

use App\Models\barang;
use Exception;
use Illuminate\Http\Request;

class barangcontroller extends Controller {
    public function read() {
        // get all data barang
        $barang = barang::all();
        // jika barang empty maka
        if ($barang->isEmpty()) {
            return response()->json([
                'status'=>'fail',
                'message'=>'Data is empty'
            ], 404);
        }
        // jika tidak
        return response()->json($barang, 200);
    }

    public function add(Request $request) 
    {
        // data barang dari user
        $barang = new barang([
            'kodebarang' => $request->input('kodebarang'),
            'namabarang' => $request->input('namabarang'),
            'hargabarang' => $request->input('hargabarang'),
            'stokbarang' => $request->input('stokbarang'),
            'gambarbarang' => $request->input('gambarbarang')
        ]);
        // cek models/db, jika berhasil
        if($barang->save()) {
            return response()->json([
                'message' => 'Barang berhasil di simpan ke database',
                'data' => $barang
            ], 200);
        }
        // jika barang gagal disimpan
        return response()->json([
            'status' => 'fail',
            'message' => 'Barang gagal di simpan'
        ], 500);
    }

    public function update(Request $request, $id) {
        // cari barang berdasarkan id dari user
        $barang = barang::find($id);
        // cek, jika barang dgn id yang dimaksud ada di db
        if (!$barang) {
            // kalau kosong maka
            return response()->json([
                'status' => 'fail',
                'message' => 'Barang tidak ditemukan'
            ], 404);
        } 
        // terima data barang dari user
        $barang->kodebarang = $request->input('kodebarang');
        $barang->namabarang = $request->input('namabarang');
        $barang->hargabarang = $request->input('hargabarang');
        $barang->stokbarang = $request->input('stokbarang');
        $barang->gambarbarang = $request->input('gambarbarang');
        // simpan perubahan
        $barang->save();
        // respons suksess
        return response()->json([
            'status' => 'success',
            'message' => 'Barang berhasil diubah',
            'data' => $barang
        ], 200);
    }

    public function delete($id) {
        $barang = barang::find($id);
        try {
            // jika barang tidak ada
            if (!$barang) {
                response()->json([
                    'status' => 'fail',
                    'message' => 'Barang tidak ditemukan'
                ], 404);
            } else {
                // hapus
                $barang->delete();
                // respons
                return response()->json([
                    'status' => 'success',
                    'message' => 'Barang berhasil dihapus'
                ], 200);
            }
        } catch (Exception $e) {
            return response()->json([
                'status' => 'fail',
                'message' => $e
            ], 500);
        }

    }
}