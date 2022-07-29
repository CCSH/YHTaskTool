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
    
    s.dependency "MBProgressHUD"
    s.dependency "SHPopView"
    s.dependency 'SHExtension/UIView'
    s.dependency 'SHExtension/UIButton'

end
