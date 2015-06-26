require 'byebug'
class Report

  PATTERNS = {:route => /add route \D+ \D+ \d+ \d+ \d+/,
             :aircraft => /add aircraft \S+ \d/,
             :general_passanger => /add general \D+ \d{1,3}/,
             :airline_passanger => /add airline \D+ \d{1,3}/,
             :loyalty_passanger => /add loyalty \D+ \d{1,3} \d+ (TRUE|FALSE) (TRUE|FALSE)/}

  ROUTE_KEYS = [:origin,:destination,
                :cost_pp,:price_pp,
                :min_pct]
  ROUTE_CONV = [:to_s,:to_s,
                :to_f,:to_f,
                :to_f]  

  AIRCRAFT_KEYS = [:name,:seats_number]
  AIRCRAFT_CONV = [:to_s,:to_f]           
         

  attr_reader :input_file,:output_file,:extract,:errors           

  include File_helper

  def initialize
    @extract = {}
    @errors = []
  end

  def set_error(text)
    @errors << text
  end

  def read_inputs
    puts "Input file with data:"
    @input_file = gets.chomp
    puts "Input destination file:"
    @output_file = gets.chomp
  end
  #just a helper for test of report_spec
  def set_files(input = "./sample1.txt",output = './dest1.txt')
    @input_file = input
    @output_file = output
    @extract = load_file(@input_file,PATTERNS)
  end

  def extract_data
    @extract = load_file(input_file,PATTERNS)
    set_error("Wrong number of routes") if @extract[:route].size != 1
    set_error("Wrong number of aircrafts") if @extract[:aircraft].size != 1
  end

  #reads given data and converts it into hash/dictionary
  def convert_to_hash(symbol,start_from=2,keys,conv)
    result = {}
    @extract[symbol][0].split(' ')[start_from..-1].each_with_index do |el,ix|
      result[keys[ix]] = el.send(conv[ix])
    end
    result
  end



end