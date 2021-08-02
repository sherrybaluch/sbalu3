<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Inventory extends Model
{
    protected $table = 'inventory';

    public function status()
    {
        return $this->belongsTo('App\Status');
    }
}
