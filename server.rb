require 'nokogiri'
require 'open-uri'
require 'sinatra'
require 'unirest'
#
# indeed.com
# get job title, salary, requirements, and company and email
# make hash
# def cover letter
#   text = to email ; hi company, i am intereseted in job title
# end

$jobs = []

class Job
  attr_accessor :title, :company, :reqs, :id, :salary
  def initialize(title, company, reqs, id, salary)
    @title = title
    @company = company
    @reqs = reqs
    @id = id
    @salary = salary
end
end
$text = ""
$x = 1

def scrape(url)
  doc = Nokogiri::HTML(open(url))
  div = doc.css('div.result')
  id = $x
  div.each do |div|
    title = div.css('a.jobtitle').text.strip
    if title == nil || title == ""
      title = "Developer"
    end
    company = div.css('span.company').text.strip
    if company == nil || company == ""
      company = "your company"
    end
    reqs = div.css('span.experienceList').text.strip
    if reqs == nil || reqs == ""
      reqs = "Javascript and Ruby"
    end
  salary = div.css('span.no-wrap').text.strip
    if salary == nil || salary == ""
      salary = "Salary unknown"
    end
    url = div.css('a.jobtitle[href]')
    $job = Job.new(title, company, reqs, id, salary)
    $jobs << $job
    id += 1
  end

end

scrape('https://www.indeed.com/jobs?q=ruby&l=New+York+City%2C+NY')
10.times do
$x = $jobs[-1].id + 1
scrape('https://www.indeed.com/jobs?q=ruby+%24100%2C000&l=New+York+City%2C+NY&start=' + $jobs[-1].id.to_s + '')
end

get '/' do
$jobs.each_index do |job|
  if $jobs[job].salary != "Salary unknown"
$text << "<p style='background-color:yellow;'><a href='/" + $jobs[job].id.to_s + "'>" + $jobs[job].id.to_s + "</a>: " + $jobs[job].title + " at " + $jobs[job].company + ", " + $jobs[job].salary + "</p>"
  else
$text << "<p><a href='/" + $jobs[job].id.to_s + "'>" + $jobs[job].id.to_s + "</a>: " + $jobs[job].title + " at " + $jobs[job].company + ", " + $jobs[job].salary + "</p>"
end
end
"#{$text}"
end

get '/:id' do
   @id = params[:id]
  @job = $jobs.index { |j| @id == j.id.to_s }
  $text_i = "<p> To whom it may concern;</p><p> I am intereseted in the position of " + $jobs[@job].title + " at " + $jobs[@job].company + ".<br>I am a full-stack web developer with experience in " + $jobs[@job].reqs + ".<br>This cover letter was generated using Nokogiri and Sinatra.</p><p>Thank you for your consideration,</p><p>Milo Wissig</p>"
  "#{$text_i}"
end

#
# http://localhost:4567
