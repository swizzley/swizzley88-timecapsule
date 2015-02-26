#
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "swizzley88-timecapsule"

  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dustin Morgan"]
  s.date = "2015-02-25"
  s.description = [ 'This Gem format of the timecapsule module is intended to make',
                    'install` command to install timecapsule from the [Puppet',
                    'Forge](https://forge.puppetlabs.com/swizzley88/timecapsule).' ].join(' ')
  s.email = "morgan@aspendenver.org"
  s.executables = []
  s.files = [ 'CHANGELOGi.md', 'Gemfile', 'LICENSE', 'Modulefile','README.md', 'Rakefile', 'spec/spec.opts' ]
  s.files += Dir['manifests/**/*.pp'] + Dir['tests/**/*.pp'] + Dir['spec/**/*.rb']
  s.homepage = "https://forge.puppetlabs.com/swizzley88/timecapsule"
  s.rdoc_options = ["--title", "Swizzley Timecapsule Gem", "--main", "README.md", "--line-numbers"]
  s.summary = "This gem provides a way to make the timecapsule module spec testing tasks."

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.1.0') then
    else
    end
  else
  end
end
