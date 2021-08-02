<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>CSC561 | Lab1c</title>
  </head>
<body>

<h3>Status of all of our inventory items - (Inventory -> { belongsTo } -> Status)</h3>

<table border="1">
				<thead>
          <th>Inventory Item</th>
					<th>Description</th>
				</thead>

				<tbody>
					  @foreach ($inventories as $inventory)
            <tr>
                    <td>{{ $inventory->description }}</td>
					  	      <td>{{ $inventory->status->description }}</td>
            </tr>
             @endforeach

        </tbody>
</table> 

<h3>Inventory Items that have a status of Checked Out - (Status -> { hasMany } -> Inventory)</h3>

<table border="1">
				        <thead>
                    <th>Inventory Item</th>
					          <th>Description</th>
				        </thead>

				        <tbody>
					          @foreach ($statuses->where('description', 'Checked Out')->first()->inventory as $checked_out_inventory)
                    <tr>
                            <td>{{ $checked_out_inventory->description }}</td>
							              <td>{{ $checked_out_inventory->status->description }}</td>
                    </tr>
                     @endforeach

                </tbody>
</table>

<h3>List All Transactions for user_id 1</h3>

<table border="1">
	<thead>
    <th>id</th>
    <th>user_id</th>
    <th>inventory_id</th>
    <th>checkout_time</th>
    <th>scheduled_checkin_time</th>
    <th>actual_checkin_time</th>
	</thead>

	<tbody>
		@foreach ($transactions as $record)
      @if ($record->user_id == 1)
        <tr>
            <td>{{ $record->id }}</td>
            <td>{{ $record->user_id }}</td>
            <td>{{ $record->inventory_id }}</td>
            <td>{{ $record->checkout_time }}</td>
            <td>{{ $record->scheduled_checkin_time }}</td>
            <td>{{ $record->actual_checkin_time }}</td>
        </tr>
      @endif
    @endforeach
  </tbody>
</table>

<h3>List All Transactions Before September 3, 2018</h3>

<table border="1">
	<thead>
    <th>first_name</th>
    <th>description</th>
    <th>checkout_time</th>
    <th>status</th>
	</thead>

	<tbody>
		@foreach ($transactions2 as $record2)
        <tr>
            <td>{{ $record2->first_name }}</td>
            <td>{{ $record2->inv_description }}</td>
            <td>{{ $record2->checkout_time }}</td>
            <td>{{ $record2->stat_description }}</td>
        </tr>

    @endforeach
  </tbody>
</table>

</body>
</html>
