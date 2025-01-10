<?php
namespace App\Http\Controllers;

use App\Models\pelanggan;
use Exception;
use Illuminate\Http\Request;

class pelanggancontroller extends Controller {
    public function read() {
        // get all data pelanggan
        $pelanggan = pelanggan::all();
        // jika data pelanggan empty maka
        if ($pelanggan->isEmpty()) {
            return response()->json([
                'status'=>'fail',
                'message'=>'Data is empty'
            ], 404);
        }
        // jika tidak
        return response()->json($pelanggan, 200);
    }

    public function add(Request $request) 
    {
        // data pelanggan dari user
        $pelanggan = new pelanggan([
            'namapelanggan' => $request->input('namapelanggan'),
            'nohp' => $request->input('nohp'),
            'email' => $request->input('email'),
        ]);
        // cek models/db, jika berhasil
        if($pelanggan->save()) {
            return response()->json([
                'message' => 'Pelanggan berhasil di simpan ke database',
                'data' => $pelanggan
            ], 200);
        }
        // jika pelanggan gagal disimpan
        return response()->json([
            'status' => 'fail',
            'message' => 'Pelanggan gagal di simpan'
        ], 500);
    }

    public function update(Request $request, $id) {
        // cari pelanggan berdasarkan id dari user
        $pelanggan = pelanggan::find($id);
        // cek, jika pelanggan dgn id yang dimaksud ada di db
        if (!$pelanggan) {
            // kalau kosong maka
            return response()->json([
                'status' => 'fail',
                'message' => 'Pelanggan tidak ditemukan'
            ], 404);
        } 
        // terima data pelanggan dari user
        $pelanggan->namapelanggan = $request->input('namapelanggan');
        $pelanggan->nohp = $request->input('nohp');
        $pelanggan->email = $request->input('email');
        // simpan perubahan
        $pelanggan->save();
        // respons suksess
        return response()->json([
            'status' => 'success',
            'message' => 'Pelanggan berhasil diubah',
            'data' => $pelanggan
        ], 200);
    }

    public function delete($id) {
        $pelanggan = pelanggan::find($id);
        try {
            // jika pelanggan tidak ada
            if (!$pelanggan) {
                response()->json([
                    'status' => 'fail',
                    'message' => 'Pelanggan tidak ditemukan'
                ], 404);
            } else {
                // hapus
                $pelanggan->delete();
                // respons
                return response()->json([
                    'status' => 'success',
                    'message' => 'Pelanggan berhasil dihapus'
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