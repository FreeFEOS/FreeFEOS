Pod::Spec.new do |s|
  s.name             = 'freefeos'
  s.version          = '0.0.1'
  s.summary          = 'FreeFEOS'
  s.description      = <<-DESC
A new Flutter FFI plugin project.
                       DESC
  s.homepage         = 'https://github.com/freefeos/freefeos'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'wyq0918dev' => 'wyq0918dev@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.script_phase = {
    :name => 'Build System Kernel',
    :script => 'sh "$PODS_TARGET_SRCROOT/../cargokit/build_pod.sh" ../rust freefeos',
    :execution_position => :before_compile,
    :input_files => ['${BUILT_PRODUCTS_DIR}/cargokit_phony'],
    :output_files => ["${BUILT_PRODUCTS_DIR}/libfreefeos.a"],
  }
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'OTHER_LDFLAGS' => '-force_load ${BUILT_PRODUCTS_DIR}/libfreefeos.a',
  }
end