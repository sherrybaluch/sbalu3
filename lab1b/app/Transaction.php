<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    public function inventory()
    {
        return $this->belongsTo('App\Inventory');
    }

    public function user()
    {
        return $this->belongsTo('App\User');
    }

}
