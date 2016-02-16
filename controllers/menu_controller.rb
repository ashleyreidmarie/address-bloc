require_relative '../models/address_book'

class MenuController
  attr_accessor :address_book
  
  def initialize
    @address_book = AddressBook.new
  end
  
  def main_menu
    puts "Main Menu - #{@address_book.entries.count} entries"
    puts "1 - View all entries"
    puts "2 - View entry by number"
    puts "3 - Create an entry"
    puts "4 - Search for an entry"
    puts "5 - Import entries from a CSV"
    puts "6 - Exit"
    print "Enter your selection: "
    
    selection = gets.to_i
    
    case selection
    when 1
      system "clear"
      view_all_entries
      main_menu
    when 2
      system "clear"
      #implement failsafe if there are no entries to view
      if @address_book.entries.count > 0
        entry_by_number_submenu
      else
        puts "There are no current entries"
      end
      main_menu
    when 3
      system "clear"
      create_entry
      main_menu
    when 4
      system "clear"
      search_entries
      main_menu
    when 5
     system "clear"
     read_csv
     main_menu
    when 6
     puts "Good-bye!"
     exit(0)
    else
      system "clear"
      puts "Sorry, that is not a valid input"
      main_menu
    end
  end

  
  def view_all_entries
    @address_book.entries.each do |entry|
      system "clear"
      entry_submenu(entry)
    end
    system "clear"
    puts "End of entries"
  end
  
  def entry_by_number_submenu
    print "Entry number to view #{@address_book.entries_range}: "
      selection = gets.to_i
      
    if selection > 0 && selection <= @address_book.entries.count
      #created separate method to view single entry by number so it is usable in other locations
      #subtract 1 to selection number because a regular person wouldn't think of the first entry in an array to be '0'
      view_entry_number(selection-1)
    else
      puts "That is not a valid selection"
      entry_by_number_submenu
    end
  end

 
 #views an entry by index number and directs to entry submenu 
  def view_entry_number(entry_number)
    system "clear"
    @address_book.entries.each_with_index do |entry, i|
      if i == entry_number
        entry_submenu(entry)
      elsif i > entry_number
        system "clear"
        entry_submenu(entry)
      end
    end
    system "clear"
    puts "End of Entries"
  end
  
  def create_entry
    system "clear"
    puts "New AddressBloc Entry"
    
    print "Name: "
    name = gets.chomp
    print "Phone number: "
    phone = gets.chomp
    print "Email: "
    email = gets.chomp
    
    @address_book.add_entry(name, phone, email)
    
    system "clear"
    puts "New entry created"
  end
  
  def search_entries
    print "Search by name: "
    name = gets.chomp.capitalize
    
    match = @address_book.binary_search(name)
    system "clear"
    
    if match
      puts match.to_s
      search_submenu(match)
    else
      puts "No match found for #{name}"
    end
  end
  
  def delete_entry(entry)
    @address_book.entries.delete(entry)
    puts "#{entry.name} has been deleted"
  end
  
   def edit_entry(entry)
     print "Updated name: "
     name = gets.chomp
     print "Updated phone number: "
     phone_number = gets.chomp
     print "Updated email: "
     email = gets.chomp
     
     entry.name = name if !name.empty?
     entry.phone_number = phone_number if !phone_number.empty?
     entry.email = email if !email.empty?
     
     system "clear"
     puts "Updated entry:"
   end
  
  def read_csv
    print "Enter CSV file to import: "
    file_name = gets.chomp
    
    if file_name.empty?
      system "clear"
      puts "No CSV file read"
      main_menu
    end
    
    begin
      entry_count = @address_book.import_from_csv(file_name).count
      system "clear"
      puts "#{entry_count} new entries added from #{file_name}"
    rescue
      puts "#{file_name} is not a valid CSV file, please enter the name of a valid CSV file"
      read_csv
    end
  end
  
  def entry_submenu(entry)
    puts entry.to_s
    puts "\nn - next entry"
    puts "d - delete entry"
    puts "e - edit entry"
    puts "m - return to main menu"
    
    selection = gets.chomp
    case selection
    when "n"
    when "d"
      delete_entry(entry)
    when "e"
      edit_entry(entry)
      entry_submenu(entry)
    when "m"
      system "clear"
      main_menu
    else
      system "clear"
      puts "#{selection} is not a valid input"
      entry_submenu(entry)
    end
  end
  
  def search_submenu(entry)
    puts "\nd - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"
    
    selection = gets.chomp
    
    case selection
    when "d"
      system "clear"
      delete_entry(entry)
      main_menu
    when "e"
      edit_entry(entry)
      system "clear"
      main_menu
    when "m"
      system "clear"
      main_menu
    else
      system "clear"
      puts "#{selection} is not a valid input"
      puts entry.to_s
      search_submenu(entry)
    end
  end
end