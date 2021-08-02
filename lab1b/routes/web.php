<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/
Route::get('/part1', ['uses' => 'TransactionController@part1', 'as' => 'part1']);
Route::get('/part2', ['uses' => 'TransactionController@part2', 'as' => 'part2']);
Route::get('/', ['uses' => 'TransactionController@index', 'as' => 'index']);
Route::resource('transactions', 'TransactionController');
