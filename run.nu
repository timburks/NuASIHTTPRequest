(load "NuASIHTTPRequest")

(set AWS-SECRET-ACCESS-KEY (((NSProcessInfo processInfo) environment) AWS-SECRET-ACCESS-KEY:))
(set AWS-ACCESS-KEY (((NSProcessInfo processInfo) environment) AWS-ACCESS-KEY:))

(ASIS3Request setSharedSecretAccessKey:AWS-SECRET-ACCESS-KEY)
(ASIS3Request setSharedAccessKey:AWS-ACCESS-KEY)

(set request (ASIS3BucketRequest requestWithBucket:"com.radtastical.xmachine"))

;(request setPrefix:"images/jpg")
(request setMaxResultCount:50)
(request startSynchronous)
(unless (request error)
        (puts "results")
        (puts ((request objects) description)))
(puts ((request error) description))

(puts "done")
