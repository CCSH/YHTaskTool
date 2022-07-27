Pod::Spec.new do |s|
    s.name         = "YHTaskTool"
    s.version      = "0.0.1"
    s.summary      = "炎黄任务组件"
    s.license      = "MIT"
    s.authors      = { "CCSH" => "624089195@qq.com" }
    s.platform     = :ios, "9.0"
    s.requires_arc = true
    s.homepage     = "https://github.com/CCSH/YHTaskTool"
    s.source       = { :git => "https://github.com/CCSH/YHTaskTool.git", :tag => s.version }
    
    s.source_files = "#{s.name}/*.{h,m}"
    s.resources = "#{s.name}/#{s.name}.bundle"
    
    s.dependency "MBProgressHUD", '~> 1.2.0'
    s.dependency "SHPopView", '~> 1.1.0'
    s.dependency 'SHExtension/UIView', '~> 1.5.5'
    s.dependency 'SHExtension/UIButton', '~> 1.5.5'

end
