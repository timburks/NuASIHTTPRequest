;; Sample code illustrating the use of ASIHTTPRequest's S3 support with Nu.
;; It assumes the current directory contains three subdirectories of images.
;; These subdirectories are named "small" "medium" and "large" and the
;; script copies them to S3.

(load "NuASIHTTPRequest")

;; Amazon access keys are read from environment variables.
(set AWS-SECRET-ACCESS-KEY (((NSProcessInfo processInfo) environment) AWS-SECRET-ACCESS-KEY:))
(set AWS-ACCESS-KEY (((NSProcessInfo processInfo) environment) AWS-ACCESS-KEY:))
(ASIS3Request setSharedSecretAccessKey:AWS-SECRET-ACCESS-KEY)
(ASIS3Request setSharedAccessKey:AWS-ACCESS-KEY)

(set BUCKET "my-bucket")

;; Build a set containing the names of the images already uploaded
(set availableImages (NSMutableSet set))
(set request (ASIS3BucketRequest requestWithBucket:BUCKET))
(request setPrefix:"images/covers")
(request setMaxResultCount:2000)
(request startSynchronous)
(if (request error)
    (then (puts ((request error) description)))
    (else ((request objects) each:
           (do (object)
               (availableImages addObject:(object key))))))

;; Traverse directories and upload images
('("small" "medium" "large") each:
  (do (size)
      (set files ((NSFileManager defaultManager) contentsOfDirectoryAtPath:size error:nil))
      (files each:
             (do (file)
                 (set key (+ "images/covers/" size "/" file))
                 (unless (availableImages containsObject:key)
                         (set path (+ size "/" file))
                         (puts key)
                         (set request (ASIS3ObjectRequest PUTRequestForFile:path
                                           withBucket:BUCKET
                                           key:key))
                         (request startSynchronous))))))
