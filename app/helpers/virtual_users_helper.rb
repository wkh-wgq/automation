module VirtualUsersHelper
  def virtual_user_field_options(field, virtual_user, generator = nil)
    options = {
      class: "form-control",
      readonly: virtual_user.new_record?
    }

    if virtual_user.new_record?
      options[:value] = generator.call if generator
    else
      options[:value] = virtual_user.send(field)
    end

    options
  end

  def generate_gender
    ['male', 'female'].sample
  end

  def generate_name(gender)
    gender == 'female' ? Faker::Name.female_first_name : Faker::Name.male_first_name
  end

  def generate_birthday
    rand(Date.new(1975, 1, 1)..(Date.today - 18.years)).strftime('%Y-%m-%d')
  end

  def generate_mobile
    "#{['080', '090'].sample}#{Faker::Number.number(digits: 8)}"
  end

  def english_only?(text)
    text.to_s.match?(/^[A-Za-z]+$/)
  end
end
