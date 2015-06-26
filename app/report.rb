class Report

  PATTERNS = {:route => /add route \D+ \D+ \d+ \d+ \d+/,
             :aircraft => /add aircraft \S+ \d/,
             :general_passanger => /add general \D+ \d{1,3}/,
             :airline_passanger => /add airline \D+ \d{1,3}/,
             :loyalty_passanger => /add loyalty \D+ \d{1,3} \d+ (TRUE|FALSE) (TRUE|FALSE)/}

         

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
    # read_inputs
    @extract = load_file(input_file,PATTERNS)
    set_error("Wrong number of routes") if @extract[:route].size != 1
    set_error("Wrong number of aircrafts") if @extract[:aircraft].size != 1
  end



end