#!/usr/bin/ruby

import 'org.apache.hadoop.hbase.client.HTable'
import 'org.apache.hadoop.hbase.client.Put'
import 'org.apache.hadoop.hbase.client.Scan'
import 'org.apache.hadoop.hbase.util.Bytes'


def jbytes( *args )
    return args.map { |arg| arg.to_s.to_java_bytes }
end

foods_table = HTable.new( @hbase.configuration, 'foods' )

scanner = foods_table.getScanner( Scan.new )

count = 0

# Read the source data file into a variable.
#content = File.read("Food_Display_Table.xml")

# Read from incoming text stream
content = STDIN.read

# Once read, search/parse it for the food data
# %r allows use of different regex delimeter. Needed since our search
# patterns contains forward slashes.
foodblock_pattern = %r\<Food_Display_Row>(.+?)</Food_Display_Row>\

print "Matches found: " 
print content.scan(foodblock_pattern).size

foodkey_pattern = %r\<Display_Name>(.+?)</Display_Name>\
general_pattern = %r\<(.+?)>(.+?)</\

# test the regex search to see if we can split the content into individual foods
content.scan(foodblock_pattern) do |food_data|

	# 1) Get a key for the row (parse from the textblock using REGEX)
	key = foodkey_pattern.match(food_data[0])[1]
	puts key
	# 2) Use the key to create (put) a new row in the table
	p = Put.new( *jbytes( key ) ) # create the row with a unique key
	food_data[0].scan(general_pattern) do |captures|
		p.add( *jbytes( "fact", captures[0], captures[1] ) )
	end
	p.setWriteToWAL( false )
	foods_table.put( p ) # commit the write

end
exit
