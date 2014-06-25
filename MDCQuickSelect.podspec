Pod::Spec.new do |s|
  s.name         = "MDCQuickSelect"
  s.version      = "0.1.0"
  s.summary      = 'Categories to quickly select the "n-th most" element, or the "n most" elements in an array.'
  s.description  = <<-DESC
                   Categories to quickly select the "n-th most" element, or the "n most"
                   elements (unsorted) in an array.

                   For example, if you need to find the tenth smallest number in an array of 100,000:

                   ```objc
                   #import <MDCQuickSelect/MDCQuickSelect.h>

                   // 79% faster than sorting the numbers and accessing -objectAtIndex:10
                   NSNumber *tenth = [numbers mdc_objectAtIndex:10
                                       inSortedArrayUsingComparator:^NSComparisonResult(NSNumber *left, NSNumber *right) {
                                           return [left compare: right];
                                       }];
                   ```

                   Or to find the ten smallest numbers in an array of 100,000:

                   ```objc
                   // 71% faster than sorting the numbers and accessing -subarrayWithRange:NSMakeRange(0, 10)
                   [numbers mdc_subarrayWithRange:NSMakeRange(0, 10)
                    inSortedArrayUsingComparator:^NSComparisonResult(NSNumber *left, NSNumber *right){
                                                     return [left.numberOfFriends compare:right.numberOfFriends];
                                                 }];
                   ```

                   The improved performance is achieved by using the quickselect algorithm, developed by
                   Tony Hoare, inventor of quicksort.

                   Performance is infinitesimally worse when array size is less than 150 elements. For arrays
                   larger than 150 elements, MDCQuickSelect outperforms the naive approach, sometimes by vast margins.
                   Run the benchmarking tests and see for yourself!
                   DESC
  s.homepage     = "https://github.com/modocache/MDCQuickSelect"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author           = { "modocache" => "modocache@gmail.com" }
  s.social_media_url = "http://twitter.com/modocache"

  s.source           = { :git => "https://github.com/modocache/MDCQuickSelect.git",
                          :tag => "v#{s.version}" }
  s.source_files     = "MDCQuickSelect/**/*.{h,m}"
  s.xcconfig         = { "OTHER_LDFLAGS" => '-all_load' }
  s.requires_arc     = true
end

