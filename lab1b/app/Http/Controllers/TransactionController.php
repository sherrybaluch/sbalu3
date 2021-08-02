<?php

namespace App\Http\Controllers;

use App\Transaction;
use App\Inventory;
use App\Status;

use Illuminate\Http\Request;

class TransactionController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $inventories = Inventory::all();

        //dd($inventories);

        $statuses = Status::all();

        //dd($statuses);

        $transactions = Transaction::all();

        $transactions2 = Transaction::join('users','transactions.user_id','=','users.id')
            ->join('inventory','transactions.inventory_id','=','inventory.id')
            ->join('status','inventory.status_id','=','status.id')
            ->select('users.first_name','inventory.description AS inv_description','checkout_time','status.description AS stat_description')
            ->where('checkout_time','<','2018-09-03 00:00:00')
            ->get();

        return view('transaction.index')->with('inventories', $inventories)->with('statuses', $statuses)->with('transactions', $transactions)->with('transactions2', $transactions2);
    }


    /**
     * Handles lab 1 question 1
     * 
     * "Show all items that user1 has checked out with the corresponding checkout_time.
     * Display the results.
     */
    public function part1() 
    {

        $transactions = Transaction::all(); // Get ALL records. ???

        return view('transaction.index_1')->with('transactions', $transactions);

    }




    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Transaction  $transaction
     * @return \Illuminate\Http\Response
     */
    public function show(Transaction $transaction)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Transaction  $transaction
     * @return \Illuminate\Http\Response
     */
    public function edit(Transaction $transaction)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Transaction  $transaction
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Transaction $transaction)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Transaction  $transaction
     * @return \Illuminate\Http\Response
     */
    public function destroy(Transaction $transaction)
    {
        //
    }
}
