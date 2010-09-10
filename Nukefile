
(unless ((NSFileManager defaultManager) fileExistsAtPath:"asi-http-request")
	(system "git clone http://github.com/pokeb/asi-http-request.git"))

;; source files
(set @m_files     (filelist "^asi-http-request/Classes/[^\/]*.m$"))
(@m_files unionSet:(filelist "^asi-http-request/Classes/S3/.*.m$"))
(@m_files unionSet:(filelist "^asi-http-request/Classes/CloudFiles/.*.m$"))

;; remove iPhone-specific file
(@m_files removeObject:"asi-http-request/Classes/ASIAuthenticationDialog.m")

(set SYSTEM ((NSString stringWithShellCommand:"uname") chomp))
(case SYSTEM
      ("Darwin"
               (set @arch (list "x86_64" ))
               (set @cflags "-g -std=gnu99 -fobjc-gc -DDARWIN -Iasi-http-request/Classes/S3 -Iasi-http-request/Classes/CloudFiles -Iasi-http-request/Classes")
               (set @ldflags  "-framework Foundation -framework CoreServices -framework SystemConfiguration -framework Nu -lz"))
      ("Linux"
              (set @arch (list "i386"))
              (set gnustep_flags ((NSString stringWithShellCommand:"gnustep-config --objc-flags") chomp))
              (set gnustep_libs ((NSString stringWithShellCommand:"gnustep-config --base-libs") chomp))
              (set @cflags "-g -std=gnu99 -DLINUX -I/usr/local/include #{gnustep_flags}")
              (set @ldflags "#{gnustep_libs} -lNu -lz"))
      (else nil))

;; framework description
(set @framework "NuASIHTTPRequest")
(set @framework_identifier "nu.programming.asihttprequest")
(set @framework_creator_code "????")

(compilation-tasks)
(framework-tasks)

(task "clean" is 
      (SH "rm -rf build"))

(task "clobber" => "clean" is
      (SH "rm -rf #{@framework_dir}"))

(task "default" => "framework")

(task "doc" is (SH "nudoc"))

