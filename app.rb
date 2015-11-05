require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	return SQLite3::Database.new 'barbershop.db'
end

def get_dbarber 
	return SQLite3::Database.new 'barber.db'
end

# def select_barber bb
# 	db = get_dbarber
# 		db.results_as_hash = true
# 		db.execute "select * from Barbers" do |row|
# 		string = "<option>#{row['name']}</option>"
# 	 	bb = bb.to_s + string
# 		end
# end

#=====================================CREATE TABLES===================================
configure do 												#
	db = get_dbarber  										#
	db.execute 'CREATE TABLE IF NOT EXISTS 						
			"Users" 
			(
				"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
				"username" TEXT, 
				"phone" TEXT, 
				"datestamp" TEXT, 
				"barber" TEXT, 
				"color" TEXT
			)'
	db = get_dbarber
	db.execute 'CREATE TABLE IF NOT EXISTS "Barbers" 
		     (
				"name" TEXT PRIMARY KEY 
				)'
end
#====================================================================================
get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/contacts' do
	erb :contacts
end

get '/visit' do
	db = get_dbarber
		db.results_as_hash = true
		db.execute "select * from Barbers" do |row|
		string = "<option>#{row['name']}</option>"
	 	@barberdb = @barberdb.to_s + string
		end
	erb :visit
end

get '/about' do
	erb :about

end


#================================POST SHOUSERS===================//
post '/showusers' do
			@newbarber = params[:newbarber]
		db = get_dbarber
		db.execute 'INSERT OR REPLACE INTO
			Barbers ( name ) 
		values ( ? )', [@newbarber]
	redirect :showusers	
end
#================================================================//
get '/showusers' do
	db = get_db
		db.results_as_hash = true
		db.execute "select * from Users" do |row|
				string = "<tr>
		          <th scope='row'>#{row['id']}</th>
		          <td>#{row['username']}</td>
		          <td>#{row['phone']}</td>
		          <td>#{row['datestamp']}</td>
		          <td>#{row['barber']}</td>
		          <td>#{row['color']}</td>
		        </tr>"
			 	@tabledb = @tabledb.to_s + string
			 	end
	erb :showusers
end
#==================================================================//
#============================== POST VISIT   ===================//
post '/visit' do

	@name = params[:name]
	@phone = params[:phone]
	@barber = params[:barber]
	@datestamp = params[:datestamp]
	@col = params[:col]	
	
		
		hh = {:name => 'Введите имя', :phone => 'Введите номер телефона', 
			  :datestamp => 'Выберите время и дату'}

	hh.each do |k, v|
		if params[k] == ''
			@error = hh.select {|k,_| params[k] == ""}.values.join(", ")
			return erb :visit 			
		end
	end		


	if @error != ''
		db = get_db
		db.execute 'insert into 
			Users ( username, phone, datestamp, barber, color ) 
		values ( ?, ?, ?, ?, ? )', [@name, @phone, @datestamp, @barber, @col]
		erb :visit
	end	
		
end
#============================================================\\\
#======================E-Mail Form Post ===================== \\\      
post '/contacts' do
    mail = params[:mail]
    body = params[:body]

        Pony.mail(:to => 'exempt.ir62@gmail.com', :from => "#{mail}", 
        	:subject => "art inquiry from #{mail}", :body => "#{body}", 
        	:via_options => {
        	:address 			  => 'smtp.gmail.com',
		    :port                 => '587',
		    :enable_starttls_auto => true,
		    :user_name            => 'exempt.ir62',
		    :password             => '****',
		    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
		    :domain               => "localhost.localdomain"})

        erb :contacts
end
         
