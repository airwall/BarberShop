require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exist? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers

	barbers.each do |barber|
		if !is_barber_exist? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end

end

def get_db
	return SQLite3::Database.new 'barbershop.db'
end

before do
	db = get_db
	db.results_as_hash = true
	@barbers = db.execute "select * from Barbers order by name"
end

#=====================================CREATE TABLES===================================
configure do 												#
	db = get_db 										#
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
	
	db.execute 'CREATE TABLE IF NOT EXISTS "Barbers" 
		     (	
		     	"id" INTEGER PRIMARY KEY AUTOINCREMENT,
				"name" TEXT 
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
	# db = get_db
	# db.results_as_hash = true
	# @resultbarber = db.execute "select * from Barbers order by name" 
	erb :visit
end
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
get '/about' do
	erb :about
end
#================================POST SHOWUSERS===================//
post '/showusers' do
		db = get_db
		seed_db db, [params[:newbarber]]
	redirect :showusers	
end
#==============================LIST DATABASE=============================//
get '/showusers' do
	db = get_db
	db.results_as_hash = true
	@results = db.execute 'select * from Users order by id desc'
	erb :showusers
end
#==================================================================//

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
         
