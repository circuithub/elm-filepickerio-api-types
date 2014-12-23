module FilepickerIO.Api.Type where
{-| Some basic schema for working with [filepicker.io](https://developers.filepicker.io)
-}

-- # Basic types
type alias Progress = Int
type Access = Public | Private

-- # Basic picker options and picker result
type alias PickerOptions =
  { maxSize            : Int              -- 1024*1024
  , extensions         : List String      -- ['.js', '.coffee',...]
  {-, extension        : String           -- '.pdf'-}
  , container          : String           -- 'modal'
  , language           : String           -- 'es'
  , services           : List String      -- ['FACEBOOK','BOX',…]
  {-, service          : String           -- 'FACEBOOK'-}
  , openTo             : String           -- 'BOX'
  , debug              : Bool             -- true
  , mobile             : Bool             -- true
  , policy             : Maybe String     -- POLICY
  , signature          : Maybe String     -- SIGNATURE
  }

type alias PickerResult =
  { url                : String           -- The core Filepicker.io file url on which all other operations are based.
  , filename           : String           -- The filename of the uploaded file.
  , mimetype           : String           -- The mimetype of the uploaded file.
  , size               : Maybe Int        -- The size of the uploaded file in bytes, if available.
  , isWriteable        : Maybe Bool       -- Whether the file can be written to using 'filepicker.write'.
  }

-- # Basic store options and store result

type alias WriteOptions =
  { base64decode       : Bool             -- true
  , policy             : Maybe String     -- POLICY
  , signature          : Maybe String     -- SIGNATURE
  }

type alias StorageOptions =
  { location           : String           -- 'S3'
  , path               : String           -- '/myfiles/1234.png'
  , container          : String           -- 'user-photos'
  , base64decode       : Bool             -- true
  }

type alias StoreOptions_ a =
  { a
  | access             : Access           -- 'public'
  }
type alias StoreOptions = StoreOptions_ StorageOptions

type alias StoreResult_ a =
  { a
  | key                : String           -- The s3 key where we have stored the file
  }
type alias StoreResult = StoreResult_ PickerResult

-- # Blob 
type alias Blob =
  { url                : String           -- The most critical part of the file, the url points to where the file is stored and acts as a sort of "file path".
  , filename           : Maybe String     -- The name of the file, if available
  , mimetype           : Maybe String     -- The mimetype of the file, if available.
  , size               : Maybe Int        -- The size of the file in bytes, if available.
  , key                : Maybe String     -- If the file was stored in one of the file stores you specified or configured (S3, Rackspace, Azure, etc.), this parameter will tell you where in the file store this file was put.
  , container          : Maybe String     -- If the file was stored in one of the file stores you specified or configured (S3, Rackspace, Azure, etc.), this parameter will tell you in which container this file was put.
  , isWriteable        : String           -- This flag specifies whether the underlying file is writeable.
  , path               : String           -- The path of the Blob indicates its position in the hierarchy of files uploaded when {folders                                                                                       : true} is set.
  }

-- # Pick Files 
-- From the Cloud direct to your Site
-- filepicker.pick(picker_options, onSuccess(Blob){}, onError(FPError){})

type alias PickOptions_ a = 
  { a
  | mimetypes          : (List String)    -- ['image/*', 'text/*',…]
  }
type alias PickOptions = StoreOptions_ PickerOptions
type alias PickResult = PickerResult

pickErrors = 
  [ (101, "Closed the dialog without picking a file")
  ]

-- # Pick multiple files
-- To select multiple files at once, use the pickMultiple call.
-- filepicker.pickMultiple(picker_options, onSuccess(Blobs){}, onError(FPError){})

type alias PickMultipleOptions_ a =
  { a
  | maxFiles           : Int              -- 5
  , folders            : Bool             -- true
  }
type alias PickMultipleOptions = PickMultipleOptions_ PickerOptions
type alias PickMultipleResults = List PickerResult

pickMultipleErrors =
  [ (101, "Closed the dialog without picking a file")
  ]

-- # Pick and Store
-- filepicker.pickAndStore(picker_options, store_options, onSuccess(Blobs){}, onError(FPError){})
type alias PickAndStoreOptions_ a =
  { a
  | maxFiles           : Int              -- 5
  , multiple           : Bool             -- true
  , folders            : Bool             -- true
  }
type alias PickAndStoreOptions = PickAndStoreOptions_ PickerOptions
type alias PickAndStoreResult = StoreResult
type alias PickAndStoreResults = List PickAndStoreResult

pickAndStoreErrors =
  [ (101, "Closed the dialog without picking a file")
  , (151, "The file store couldn't be reached")
  ]

-- # Export 
-- From your site directly to the Cloud

type alias ExportOptions_ a =
  { a
  | mimetype           : String           -- 'image/*'
  }
type alias ExportOptions = ExportOptions_ PickerOptions
type alias ExportResult = PickerResult

exportErrors =
  [ (131, "Closed the dialog without exporting a file")
  ]

-- # Read Files
type alias ReadOptions = 
  { base64encode       : Bool             -- true
  , asText             : Bool             -- true
  , cache              : Bool             -- true
  , policy             : Maybe String     -- POLICY
  , signature          : Maybe String     -- SIGNATURE
  }

-- type alias ReadResult = ? -- TODO...

readErrors =
  [ (111, "Your browser doesn't support reading from DOM File objects")
  , (112, "Your browser doesn't support reading from different domains")
  , (113, "The website of the URL you provided does not allow other domains to read data")
  , (114, "The website of the URL you provided had an error")
  , (115, "File not found")
  , (118, "General read error")
  ]

-- # Get File Metadata
-- filepicker.stat(Blob, [options], onSuccess(metadata){}, onError(FPError){})

type alias StatOptions =
  { size               : Bool             -- true
  , mimetype           : Bool             -- true
  , filename           : Bool             -- true
  , width              : Bool             -- true
  , height             : Bool             -- true
  , uploaded           : Bool             -- true
  , writeable          : Bool             -- true
  , md5                : Bool             -- true
  , location           : Bool             -- true
  , path               : Bool             -- true
  , container          : Bool             -- true
  , policy             : Maybe String     -- POLICY
  , signature          : Maybe String     -- SIGNATURE
  }

-- type alias StatResult --TODO...

statErrors =
  [ (161 , "The file cannot be found")
  , (162 , "Error fetching metadata")
  ]

-- # Write back to a file
-- filepicker.write(target, data, [options], onSuccess(Blob){}, onError(FPError){}, onProgress(percent){})

type alias WriteResult = PickerResult

writeErrors =
  [ (111 , "Your browser doesn't support reading from DOM File objects")
  , (115 , "File not found")
  , (118 , "General read error")
  , (121 , "The Blob to write to could not be found")
  ]

-- # Write a URL back to a file
-- filepicker.writeUrl(target, URL, [options], onSuccess(Blob){}, onError(FPError){}, onProgress(percent){})

type alias WriteUrlOptions = WriteOptions
type alias WriteUrlResult = PickerResult

writeUrlErrors =
  [ (121 , "The Blob to write to could not be found")
  , (122 , "The Remote URL could not be reached.")
  ]

-- # Store a file
-- filepicker.store(input, [options], onSuccess(Blob){}, onError(FPError){}, onProgress(percent){})

storeErrors =
  [ (111, "Your browser doesn't support reading from DOM File objects")
  , (115, "File not found")
  , (118, "General read error")
  , (151, "The file store couldn't be reached")
  ]

-- # Store the contents at a URL
-- filepicker.storeUrl(URL, [options], onSuccess(Blob){}, onError(FPError){}, onProgress(percent){})

type alias StoreUrlOptions = StorageOptions
type alias StoreUrlResult = PickerResult

storeUrlErrors =
  [ (151, "The file store couldn't be reached")
  , (152, "The remote URL couldn't be reached")
  ]

-- # Convert a file
-- filepicker.convert(Blob, conversion_options, storage_options, onSuccess(Blob){}, onError(FPError){}, onProgress(percent){})

type Rotation = Exif | Rotation Int
type Fit = Clip         -- Resizes the image to fit within the specified parameters without distorting, cropping, or changing the aspect ratio
         | Crop         -- Resizes the image to fit the specified parameters exactly by removing any parts of the image that don't fit within the boundaries
         | Scale        -- Resizes the image to fit the specified parameters exactly by scaling the image to the desired size
         | Max          -- Resizes the image to fit within the parameters, but as opposed to 'clip' will not scale the image if the image is smaller than the output size
type Align = Top        -- Crop aligned with the top of the image
           | Bottom     -- Crop aligned with the bottom of the image
           | Left       -- Crop aligned with the left edge of the image
           | Right      -- Crop aligned with the right edge of the image
           | Faces      -- Search for faces, and if found, crop such that the faces are aligned in the center of the resized image.
type Filter = Blur      -- Blurs the image. You can additionally specify a "blurAmount" parameter.
            | Sharpen   -- Sharpens the image. You can additionally specify a "sharpenAmount" parameter.

type alias ConvertOptions =
  { width              : Maybe Int        -- 200
  , height             : Maybe Int        -- 200
  , fit                : Maybe Fit        -- 'clip'
  , align              : Maybe Align      -- 'faces'
  , crop               : Maybe (List Int) -- [20, 20, 100, 100]
  , format             : Maybe String     -- 'jpg'
  , filter             : Maybe Filter     -- 'blur'
  , compress           : Maybe Bool       -- true
  , quality            : Maybe Int        -- 75
  , rotate             : Maybe Rotation   -- "exif" or 180
  , watermark          : Maybe String     -- 'https                                                                                                                                                                      : //d3urzlae3olibs.cloudfront.net/watermark.png'
  , watermark_size     : Maybe Int        -- 30
  , watermark_position : Maybe String     -- 'top,right'
  , policy             : Maybe String     -- POLICY
  , signature          : Maybe String     -- SIGNATURE
  }

type alias ConvertResult = PickerResult

convertErrors =
  [ (141, "The inputted file cannot be found.")
  , (142, "The user's file cannot be converted with the requested parameters.")
  , (143, "Unknown error when converting the file.")
  ]

-- # Getting rid of a file
-- filepicker.remove(Blob, options, onSuccess(){}, onError(FPError){})

type alias RemoveOptions =
  { policy             : Maybe String     -- POLICY
  , signature          : Maybe String     -- SIGNATURE
  }

removeErrors =
  [ (171 , "The file cannot be found, and may have already been deleted")
  , (172 , "The underlying content store could not be reached")
  ]
