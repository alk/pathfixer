require 'fileutils'

module ::PathFixer
  module_function
  def sync_bin_symlinks(*args)
    return if Gem.win_platform?

    global_bindir = '/usr/local/bin'
    bindir = File.expand_path(Gem.bindir)

    return if bindir == global_bindir
    return if ENV['PATH'].split(':').include?(bindir)

    if !File.directory?(global_bindir) || !File.writable?('/usr/local/bin')
      Gem.ui.say "PathFixer: skipping #{global_bindir} synchronization because this directory doesn't exist or is not writable"
      return
    end

    installed_binaries = Dir.entries(bindir)
    installed_binaries.reject! do |entry|
      !File.file?(File.join(bindir, entry))
    end

    target_binaries = Dir.entries(global_bindir).select do |entry|
      full_path = File.join(global_bindir, entry)
      File.symlink?(full_path) && begin
                                    target = File.expand_path(File.readlink(full_path), File.dirname(full_path))
                                    File.dirname(target) == bindir
                                  end
    end

    (installed_binaries - target_binaries).each do |missing|
      Gem.ui.say "PathFixer: installing symlink on new gem binary '#{missing}' into #{global_bindir}"
      FileUtils.ln_s(File.join(bindir, missing), File.join(global_bindir, missing))
    end

    (target_binaries - installed_binaries).each do |obsolete|
      Gem.ui.say "PathFixer: removing symlink on uninstalled gem binary '#{obsolete}' from #{global_bindir}"
      FileUtils.rm_r(File.join(global_bindir, obsolete))
    end
  end
end

Gem.post_install_hooks << PathFixer.method(:sync_bin_symlinks)
Gem.post_uninstall_hooks << PathFixer.method(:sync_bin_symlinks)
