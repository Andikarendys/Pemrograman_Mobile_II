<?php
namespace App\Http\Controllers;

use App\Models\transaksi;
use Exception;
use Illuminate\Http\Request;

class transaksicontroller extends Controller {
    public function read() {
        // get all data transaksi
        $transaksi = transaksi::all();
        // jika data transaksi empty maka
        if ($transaksi->isEmpty()) {
            return response()->json([
                'status'=>'fail',
                'message'=>'Data is empty'
            ], 404);
        }
        // jika tidak
        return response()->json($transaksi, 200);
    }

    public function add(Request $request) 
    {
        // data transaksi dari user
        $transaksi = new transaksi([
            'kodetransaksi' => $request->input('kodetransaksi'),
            'namapelanggan' => $request->input('namapelanggan'),
            'nohp' => $request->input('nohp'),
            'namabarang' => $request->input('namabarang'),
            'hargabarang' => $request->input('hargabarang'),
            'jumlahbarang' => $request->input('jumlahbarang'),
            'totalharga' => $request->input('totalharga'),
        ]);
        // cek models/db, jika berhasil
        if($transaksi->save()) {
            return response()->json([
                'message' => 'Transaksi berhasil di simpan ke database',
                'data' => $transaksi
            ], 200);
        }
        // jika transaksi gagal disimpan
        return response()->json([
            'status' => 'fail',
            'message' => 'Transaksi gagal di simpan'
        ], 500);
    }

    public function update(Request $request, $id) {
        // cari transaksi berdasarkan id dari user
        $transaksi = transaksi::find($id);
        // cek, jika transaksi dgn id yang dimaksud ada di db
        if (!$transaksi) {
            // kalau kosong maka
            return response()->json([
                'status' => 'fail',
                'message' => 'Transaksi tidak ditemukan'
            ], 404);
        } 
        // terima data transaksi dari user
        $transaksi->kodetransaksi = $request->input('kodetransaksi');
        $transaksi->namapelanggan = $request->input('namapelanggan');
        $transaksi->nohp = $request->input('nohp');
        $transaksi->namabarang = $request->input('namabarang');
        $transaksi->hargabarang = $request->input('hargabarang');
        $transaksi->jumlahbarang = $request->input('jumlahbarang');
        $transaksi->totalharga = $request->input('totalharga');
        // simpan perubahan
        $transaksi->save();
        // respons suksess
        return response()->json([
            'status' => 'success',
            'message' => 'Transaksi berhasil diubah',
            'data' => $transaksi
        ], 200);
    }

    public function delete($id) {
        $transaksi = transaksi::find($id);
        try {
            // jika transaksi tidak ada
            if (!$transaksi) {
                response()->json([
                    'status' => 'fail',
                    'message' => 'Transaksi tidak ditemukan'
                ], 404);
            } else {
                // hapus
                $transaksi->delete();
                // respons
                return response()->json([
                    'status' => 'success',
                    'message' => 'Transaksi berhasil dihapus'
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