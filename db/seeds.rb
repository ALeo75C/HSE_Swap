require 'curb'

@minor_list_url = "https://electives.hse.ru/catalog2019"

def seed
  clean_db
  create_cities
end

def clean_db
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
end

def create_correct_names(name)
  name = name.capitalize
  uncorrenc_symbol_id = nil
  name = name.chars.map.with_index do |c, i|
    if (c == " " || c == "-")
      uncorrenc_symbol_id = i+1
    end
    uncorrenc_symbol_id == i ? c.capitalize : c
  end.join
end

def create_cities
  html = Curl.get(@minor_list_url)
  body_html = Nokogiri::HTML(html.body_str)

  post_text_html = body_html.css('.post__text')


  city = ''
  cities_count = 1
  faculty = ''
  minor = {minorName: "", page_url: ""}
  @faculties = []

  post_text_html.children.each do |entry|
    if entry.name == "h3"
      city = create_correct_names(entry.content)
      @city_obj = City.create!(name: city)

      if cities_count != City.all.length
        if @faculties.length == 1
          puts 'it`s Piter'
        else
          create_faculties(cities_count)
        end
        @faculties = []
        cities_count = City.all.length
      end
    end


    if entry.name == 'p'
      entry.children.each do |paragraph_entry|
        if paragraph_entry.name == 'a'
          if paragraph_entry.content == "Список доступен на портале филиала"
            spb_minors(paragraph_entry[:href])
          else
            minor[:mionrName] = paragraph_entry.content
            minor[:page_url] = paragraph_entry[:href]
            get_minor_information(paragraph_entry[:href], paragraph_entry.content)
            # minor_obj = Minor.create!(title: minor[:mionrName], city_id: @city_obj.id, location: city, page_url: minor[:page_url])
          end
        end
      end
    end
  end

  if cities_count == 4
    create_faculties(cities_count)
  end

end

def spb_minors(url)
  html = Curl.get(url)
  body_html = Nokogiri::HTML(html.body_str)
  items = body_html.css('.b-row__item')
  i = 0
  items.each do |item|
    unless i==0 || i==1
      y = 0
      item.children.each do |entry|
        if entry.name == 'div' && y==5
          entry.children.each do |div_entry|
            j = 0
            if div_entry.name = 'p'
              div_entry.children.each do |paragraph_entry|
                if paragraph_entry.name == "strong"
                  paragraph_entry.children.each do |a|
                    if a.name == 'a'
                      a.each do |a_it|
                        if j == 0
                          get_minor_information(a[:href], a.content)
                        end
                        j+=1
                      end
                    end
                  end
                end
              end
            end
          end
        end
        y += 1
      end
    end
    i += 1
  end
end


def create_faculties (city_id)
  facultiesArray = []
  @faculties.each do |faculty|
    facultiesArray.push(faculty[:faculty])
  end
  facultiesArray.uniq
  facultiesArray.each do |faculty_name|

    faculty_obj = Faculty.create!(name: faculty_name, city_id: city_id)

    @faculties.each do |faculty|
      if faculty_name == faculty[:faculty]
        mionr_obj = Minor.create!(title:faculty[:minor], faculty_id: faculty_obj.id)
      end
    end
  end
  puts City.find(city_id).name
  @faculties.each do |faculty|
  end
end

def get_minor_information(url, name)
  html = Curl.get(url)
  body_html = Nokogiri::HTML(html.body_str)
  layout = body_html.css('.layout')
  lead = layout.css('.lead-in')

  lead.children.each do |lead_entry|
    if lead_entry.name == 'a'
      @faculties.push({faculty: lead_entry.content, minor: name})
    end
  end
end

seed
