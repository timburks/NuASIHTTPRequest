;; Sample code illustrating the use of ASIHTTPRequest's Rackspace CloudFiles support with Nu.
(load "NuASIHTTPRequest")

;; Rackspace access keys are read from environment variables.
(set RS-USERNAME (((NSProcessInfo processInfo) environment) RS-USERNAME:))
(set RS-APIKEY (((NSProcessInfo processInfo) environment) RS-APIKEY:))
(set RS-CONTAINERNAME (((NSProcessInfo processInfo) environment) RS-CONTAINER:))
(set RS-CONTAINERURL (((NSProcessInfo processInfo) environment) RS-URL:))

(ASICloudFilesRequest setUsername:RS-USERNAME)
(ASICloudFilesRequest setApiKey:RS-APIKEY)
(ASICloudFilesRequest authenticate)

;; Get a list of objects in the container.
(let (request (ASICloudFilesObjectRequest listRequestWithContainer:RS-CONTAINERNAME))
     (request startSynchronous)
     (set objects (request objects))
     (objects each:
              (do (object) (puts (object name)))))

;; Put an object.
(set message "Hello!")
(set data (message dataUsingEncoding:NSUTF8StringEncoding))
(set path "testing/1/2/3/hello.txt")
(let (request (ASICloudFilesObjectRequest putObjectRequestWithContainer:RS-CONTAINERNAME
                   objectPath:path
                   contentType:"text/plain"
                   objectData:data
                   metadata:nil
                   etag:nil))
     (request startSynchronous))

;; Confirm that the object is available for download. The container must be configured properly for this to work.
(let (request (ASIHTTPRequest requestWithURL:(NSURL URLWithString:(+ RS-CONTAINERURL "/" path))))
     (request startSynchronous)
     (set response (request responseString))
     (puts response)
     (puts "success? #{(eq response message)}"))
