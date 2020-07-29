class UsersImport
  include ActiveModel::Model

  attr_accessor :file

  ALLOWED_ATTR = [
    "first_name",
    "last_name",
    "email"
  ].freeze

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
    @success_count = 0
    @failed_records = []
    @total_records = 0
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, extension: :xlsx)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def sheet_wise_import spreadsheet, sheet
    user_data = []
    spreadsheet.default_sheet = sheet
    header = spreadsheet.row(1).map(&:downcase)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = User.new
      user.attributes = row.to_hash.select { |k,v| ALLOWED_ATTR.include? k } #it maps the header with data
      user_data << user
      @total_records+=1
    end
    user_data
  end

  def load_imported_users
    sheet_wise_data = {}
    spreadsheet = open_spreadsheet
    spreadsheet.sheets.each do |sheet|
     sheet_wise_data[sheet] = sheet_wise_import(spreadsheet, sheet)
    end
    sheet_wise_data
  end

  def import_data
    load_imported_users
  end

  def save
    import_data.each do |sheet, user|
      user.each_with_index do |user, index|
        save_and_report(user, index, sheet)
      end
    end
    send_final_result
  end

  def send_final_result
    result = {}
    result[:success_count] = @success_count
    result[:failed_records_count] = @failed_records.count
    result[:failed_records] = @failed_records
    result[:total_records] =  @total_records
    result
  end

  private

  def save_and_report(user, index, sheet)
    # avoid the bang version (save!) as we don't need to handle exceptions here.
    if user.save
      @success_count += 1
    else
      @failed_records <<  "Sheet Name: #{sheet}: Row #{index + 2}: #{user.errors.full_messages.join(', ')}" 
    end
  end 

end