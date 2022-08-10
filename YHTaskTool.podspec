Pod::Spec.new do |s|
    s.name         = "YHTaskTool"
    s.version      = "0.0.3"
    s.summary      = "炎黄任务组件"
    s.license      = "MIT"
    s.authors      = { "CCSH" => "624089195@qq.com" }
    s.platform     = :ios, "9.0"
    s.requires_arc = true
    s.homepage     = "https://github.com/CCSH/#{s.name}"
    s.source       = { :git => "https://github.com/CCSH/#{s.name}.git", :tag => s.version }
    
    #s.source_files = "#{s.name}/*.{h,m}"
    #s.resources = ["#{s.name}/#{s.name}.bundle"]
    
    s.vendored_frameworks = ["#{s.name}/*.framework"]
    s.static_framework = true
    
    s.dependency "MBProgressHUD"
    s.dependency "SHPopView"
    s.dependency 'SHExtension/UIView'

end
