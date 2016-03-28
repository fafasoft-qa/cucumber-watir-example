require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

# method that allows to get data from jenkins in "tag1,tag2" form
# and convert it to "--tags @tag1 --tags @tag2" form or "--tags ~@tag1 --tags ~@tag2" form
# for AND logic between tags
def get_tags(jenkins_str,type)
  if jenkins_str.match(",") == nil
    if type=="include"
      tags = " --tags @"+ jenkins_str
    else
      tags = " --tags ~@"+ jenkins_str
    end
  else
    data = jenkins_str.split(",")
    tags=""
    data.each do |tag|
      if type=="include"
        tags =tags + " --tags @"+tag
      else
        tags =tags + " --tags ~@"+tag
      end
    end
  end
  return tags
end
# method that allows to get data related to tags that should be added to corresponding profile
def get_console_data_with_tags(include_tags,exclude_tags)
  if include_tags.downcase.match("all")!= nil
    include_tags = ""
  end

# when tags have not been indicated
  if include_tags =="" and  exclude_tags == ""
    tags = ""
  end
#when including tags have been indicated, but excluding tags haven't been indicated
  if include_tags !="" and  exclude_tags == ""
    if ENV["include_logic"] == "AND"
      tags = get_tags(include_tags,"include")
    else
      tags = "--tags @"+include_tags.gsub(",",",@")
    end
  end
#when including tags haven't been indicated, but excluding tags have been indicated
  if (include_tags =="") and  exclude_tags != ""
    if ENV["exclude_logic"] == "AND"
      tags = get_tags(exclude_tags,"exclude")
    else
      tags = " --tags ~@"+exclude_tags.gsub(",",",~@")
    end
  end
#when including and excluding tags have been indicated
  if include_tags !="" and  exclude_tags != ""
    if ENV["exclude_logic"]== "AND"  and ENV["include_logic"] == "AND"
      tags = get_tags(include_tags,"include") + get_tags(exclude_tags,"exclude")
    end
    if ENV["exclude_logic"]== "AND"  and ENV["include_logic"] == "OR"
      tags = " --tags @"+include_tags.gsub(",",",@") + get_tags(exclude_tags,"exclude")
    end
    if ENV["exclude_logic"]== "OR"  and ENV["include_logic"] == "AND"
      tags = get_tags(include_tags,"include") + " --tags ~@"+exclude_tags.gsub(",",",~@")
    end
    if ENV["exclude_logic"]== "OR"  and ENV["include_logic"] == "OR"
      tags =" --tags @"+include_tags.gsub(",",",@") + " --tags ~@"+exclude_tags.gsub(",",",~@")
    end
  end
  return tags
end

Cucumber::Rake::Task.new(:features) do |t|
  t.profile = 'default'
end

task :default => :features

#Full tests

Cucumber::Rake::Task.new(:qa_chrome) do |t|
  t.profile = 'qa_chrome'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","qa_chrome " + tags_data]
end

Cucumber::Rake::Task.new(:qa2_chrome) do |t|
  t.profile = 'qa2_chrome'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","qa2_chrome " + tags_data]
end

Cucumber::Rake::Task.new(:qa3_chrome) do |t|
  t.profile = 'qa2_chrome'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","qa3_chrome " + tags_data]
end

Cucumber::Rake::Task.new(:qa_firefox) do |t|
  t.profile = 'qa_firefox'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","qa_firefox " + tags_data]
end

Cucumber::Rake::Task.new(:qa2_firefox) do |t|
  t.profile = 'qa2_firefox'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","qa2_firefox " + tags_data]
end
Cucumber::Rake::Task.new(:qa3_firefox) do |t|
  t.profile = 'qa_firefox'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","qa3_firefox " + tags_data]
end

Cucumber::Rake::Task.new(:prod_chrome) do |t|
  t.profile = 'prod_chrome'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","prod_chrome " + tags_data]
end

Cucumber::Rake::Task.new(:prod_firefox) do |t|
  t.profile = 'prod_firefox'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","prod_firefox " + tags_data]
end

Cucumber::Rake::Task.new(:feature1_firefox) do |t|
  t.profile = 'feature1_firefox'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","feature1_firefox " + tags_data]
end

Cucumber::Rake::Task.new(:feature1_chrome) do |t|
  t.profile = 'feature1_chrome'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","feature1_chrome " + tags_data]
end

Cucumber::Rake::Task.new(:feature2_firefox) do |t|
  t.profile = 'feature2_firefox'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","feature2_firefox " + tags_data]
end

Cucumber::Rake::Task.new(:feature2_chrome) do |t|
  t.profile = 'feature2_chrome'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","feature2_chrome " + tags_data]
end

Cucumber::Rake::Task.new(:dev_firefox) do |t|
  t.profile = 'dev_firefox'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","dev_firefox " + tags_data]
end

Cucumber::Rake::Task.new(:dev_chrome) do |t|
  t.profile = 'dev_chrome'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","dev_chrome " + tags_data]
end

Cucumber::Rake::Task.new(:stage_chrome) do |t|
  t.profile = 'stage_chrome'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","stage_chrome " + tags_data]
end

Cucumber::Rake::Task.new(:stage_firefox) do |t|
  t.profile = 'stage_firefox'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","stage_firefox " + tags_data]
end

Cucumber::Rake::Task.new(:prodcwebcast_chrome) do |t|
  t.profile = 'prodcwebcast_chrome'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","prodcwebcast_chrome " + tags_data]
end

Cucumber::Rake::Task.new(:prodcwebcast_firefox) do |t|
  t.profile = 'prodcwebcast_firefox'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","prodcwebcast_firefox " + tags_data]
end

Cucumber::Rake::Task.new(:stage_cwebcast_chrome) do |t|
  t.profile = 'stage_cwebcast_chrome'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","stage_cwebcast_chrome " + tags_data]
end

Cucumber::Rake::Task.new(:stage_cwebcast_firefox) do |t|
  t.profile = 'stage_cwebcast_firefox'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","stage_cwebcast_firefox " + tags_data]
end

Cucumber::Rake::Task.new(:qacwebcast_chrome) do |t|
  t.profile = 'qacwebcast_chrome'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","qacwebcast_chrome " + tags_data]
end

Cucumber::Rake::Task.new(:qacwebcast_firefox) do |t|
  t.profile = 'qacwebcast_firefox'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,"")
  runtime_env = ENV["ENVIRONMENT"].to_s
  runtime_browser = ENV["BROWSER"].to_s
  tags= tags_data.to_s
  tags.sub! ' ', ''
  tags.sub! '--tags', 'inc'
  tags.gsub! '--', ''
  tags.gsub! '@', ''
  tags.gsub! ' ', '_'
  tags.gsub! '~', ''
  tags.gsub! '__', '_'
  tags_data = get_console_data_with_tags(ENV["INCLUDE"].to_s,ENV["EXCLUDE"].to_s)
  result_file = "result_"+runtime_env+"_"+runtime_browser+"_"+"#{Time.now.strftime('%Y%m%d@%H%M%S')}"+"_"+tags.to_s+".html"
  t.cucumber_opts = ["features --format html -o reports/"+result_file+" --format pretty","-p","qacwebcast_firefox " + tags_data]
end