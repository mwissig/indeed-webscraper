require 'nokogiri'
require 'open-uri'
require 'sinatra'
require 'unirest'


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
    reqs = div.css('span.experienceList').text.strip.split(", ")
    if reqs == []
      reqs << "Ruby"
      reqs << "JavaScript"
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
    rt = 0
      rtext = "Goodbye Ruby Tuesday"
$jobs.each_index do |job|
  if $jobs[job].company == "Ruby Tuesday"
    $text << "<p style='background-color:black; color:gray;'><a href='/letter/" + $jobs[job].id.to_s + "'>" + $jobs[job].id.to_s + "</a>: " + rtext + "</p>"
    case rt
    when 0
      rtext = "She would never say where she came from"
    when 1
      rtext = "Yesterday don't matter if it's gone"
    when 2
      rtext = "While the sun is bright"
    when 3
      rtext = "Or in the darkest night"
    when 4
      rtext = "No one knows\, she comes and goes"
    else
      rtext = "Goodbye Ruby Tuesday"
    end
    rt += 1
elsif $jobs[job].salary != "Salary unknown"
$text << "<p style='background-color:yellow;'><a href='/letter/" + $jobs[job].id.to_s + "'>" + $jobs[job].id.to_s + "</a>: " + $jobs[job].title + " at " + $jobs[job].company + ", " + $jobs[job].salary + "</p>"
  else
$text << "<p><a href='/letter/" + $jobs[job].id.to_s + "'>" + $jobs[job].id.to_s + "</a>: " + $jobs[job].title + " at " + $jobs[job].company + ", " + $jobs[job].salary + "</p>"
end
end
  erb :home
end

get '/letter/:id' do
   @id = params[:id]
  @job = $jobs.index { |j| @id == j.id.to_s }
  req = $jobs[@job].reqs.join(", ")
  @exp = {
    "JavaScript"=>"I have experience using JavaScript to write programs.",
    "Ruby"=>"I have experience in Ruby; this cover letter was written in Ruby using Nokogiri and Sinatra by webscraping Indeed.com and matching the skills you have requested values in a hash of pre-written responses.",
    "CSS"=>"I can use CSS to create transitions and animations and to create mobile responsive pages.",
    "HTML5"=>"I have 18 years of experience using HTML.",
    "AJAX"=>"I have experience making API calls using AJAX",
    "JSON"=>"I have experience using JSON objects.",
    "Software Development"=>"I write software.",
    "React"=>"I am in the process of learning React.",
    "React Native"=>"",
    "Angular"=>"I am in the process of learning Angular.",
    "Node.js"=>"I am in the process of learning Node.js.",
    "Python"=>"I am interested in learning Python.",
    "Java"=>"I am interested in learning Java.",
    "Scala"=>"I don\'t know what Scala is.",
    "Linux"=>"I use Ubuntu.",
    "Chef"=>"Time to look up what Chef is",
    "Go"=>"",
    "Ansible"=>"",
    "SQL"=>"",
    "MySQL"=>"",
    "Redis"=>"",
    "Puppet"=>"",
    "PowerShell"=>"",
    "Selenium"=>"",
    "XML"=>"",
    "Windows"=>"I am a regular Windows user.",
    ".Net"=>"",
    "C#"=>"",
    "REST"=>"I have made calls to APIS that use REST",
    "TCP/IP"=>"",
    "TCP"=>"",
    "Heroku"=>"",
    "Adobe CS"=>"I have 15 years of experience using Adobe Photoshop and Illustrator",
    "Marketing Automation"=>"",
    "Splunk"=>"",
    "iOS"=>"",
    "iOS Development"=>"",
    "Sketch"=>"",
    "Swift"=>"",
    "PHP"=>"",
    "Design Experience"=>"I have experience in graphic and web design.",
    "Design"=>"I have experience in graphic and web design.",
    "PostgreSQL"=>"",
    "C/C++"=>"",
    "Confluence"=>"",
    "Kubernetes"=>"",
    "JIRA"=>"",
    "Kafka"=>"As Gregor Samsa awoke one morning from uneasy dreams he found himself transformed in his bed into a gigantic insect.",
    "Git"=>"I use Git.",
    "AWS"=>"I don't know what AWS is.",
    "OOP"=>"This cover letter was written using object-oriented programming.",
    "Web Development"=>"I have experience with web development.",
    "CI/CD"=>"",
    "Service-Oriented Architecture"=>"",
    "Backbone.js"=>"",
    "NoSQL"=>"",
    "CI"=>"",
    "Test Automation"=>"",
    "SDLC."=>"",
    "Google Suite"=>"I have used Google Suite to create email addresses for an organization.",
    "Shell Scripting"=>"",
    "Perl"=>"",
    "Jenkins"=>"",
    "Bootstrap"=>"I have used Bootstrap.",
    "SQLite"=>"",
    "Responsive Web Design"=>"I can use media queries to create responsive design.",
    "UI"=>"",
    "Database Administration"=>"",
    "Supervising Experience"=>"",
     "AI"=>"",
     "Machine Learning"=>""

  }
  my_exp = ""
  $jobs[@job].reqs.each do |r|
    if @exp[r] != nil
    my_exp << @exp[r]
    my_exp << " "
    end
  end
  $text_i = "<p> To whom it may concern;</p><p> I am interested in the position of " + $jobs[@job].title + " at " + $jobs[@job].company + ".<br>I am a full-stack web developer looking for a job in the New York City area. " + my_exp + "</p><p>Thank you for your consideration,</p><p>Milo Wissig</p><p style='background-color:red;'>All skills needed: " + req + "</p>"
  erb :letter
end

#
# http://localhost:4567
