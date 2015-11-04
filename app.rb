require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/contacts' do
	erb :contacts
end

get '/visit' do
	erb :visit
end

get '/about' do
	erb :about

end

post '/visit' do

	@name = params[:name]
	@phone = params[:phone]
	@barber = params[:barber]
	@day = params[:day]
	@hours = params[:hours]
	@col = params[:col]
		
		hh = {:name => 'Введите имя', :phone => 'Введите номер телефона'}

	hh.each do |k, v|
		if params[k] == ''
			@error = hh.select {|k,_| params[k] == ""}.values.join(", ")
			return erb :visit 			
		end
	end		


	if @error != ''
		File.open("./public/users.txt", "a") {|l| l.write("Имя: #{@name}, Телефон: #{@phone}, К кому: #{@barber}, Когда: #{@day} - #{@hours}, Цвет: #{@col}\n====================================================================\n") }
		erb :visit
	end	
		
end

      
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
         
