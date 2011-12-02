task :default => [ 'lib/rx/support.rb' ]
task :test do
  ruby "-Ilib test/tc_input.rb"
  ruby "-Ilib test/tc_qname.rb"
  ruby "-Ilib test/tc_rexml.rb"
end

CHARCLASSES = FileList[
  "lib/rx/machine_builder.rb",
  "lib/rx/make_charclasses.rb",
  "lib/rx/autom" ,
  'lib/rx/cc/*' ]

file 'lib/rx/support.rb' => CHARCLASSES do
  ruby "-Ilib lib/rx/machine_builder.rb lib/rx/autom lib/rx"
end
