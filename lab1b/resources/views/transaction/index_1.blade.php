<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>CSC561 | Lab1c</title>
  </head>
<body>

<h3>List All Transactions</h3>

<table border="1">
	<thead>
    <th>id</th>
    <th>inventory_id</th>
    <th>checkout_time</th>
    <th>scheduled_checkin_time</th>
    <th>actual_checkin_time</th>
	</thead>

	<tbody>
		@foreach ($transactions as $record)
        <tr>
            <td>{{ $record->id }}</td>
            <td>{{ $record->inventory_id }}</td>
            <td>{{ $record->checkout_time }}</td>
            <td>{{ $record->scheduled_checkin_time }}</td>
            <td>{{ $record->actual_checkin_time }}</td>
        </tr>
        @endforeach
        </tbody>
</table> 


</body>
</html>
