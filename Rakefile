load 'tasks/setup.rb'

ensure_in_path 'lib'

task :default => 'spec:run'

PROJ.name = 'ffi-libfreenect'
PROJ.authors = ['Josh Grunzweig', 'Eric Monti']
PROJ.description = 'FFI bindings for the libfreenect OpenKinect library'
PROJ.url = nil
PROJ.version = File.open("version.txt","r"){|f| f.readline.chomp}
PROJ.readme_file = 'README.rdoc'

PROJ.spec.opts << '--color'
PROJ.rdoc.opts << '--line-numbers'
PROJ.notes.tags << "X"+"XX" # muhah! so we don't note our-self

# exclude rcov.rb and external libs from rcov report
PROJ.rcov.opts += [
  "--exclude",  "rcov", 
  "--exclude",  "ffi", 
]

depend_on 'ffi', '>= 0.6.0'

# EOF
