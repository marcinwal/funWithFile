require_relative './file_helper.rb'
require_relative './report.rb'


report = Report.new

report.read_inputs
report.extract_data
report.convert_all_data
report.save_file(report.output_file,report.final)


