module OpenProject::WikiExtension
  class Engine < ::Rails::Engine
    engine_name :openproject_video_wiki_macro

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject_wiki_extension_plugin',
             :requires_openproject => '>= 3.0.0' do

      Redmine::WikiFormatting::Macros.register do
        desc "OpenProject video macro.  Use as {{video(&lt;url&gt;[,&lt;width&gt;,&lt;height&gt;])}}."
        macro :video do |video_wiki_content, args|
          url = ""
          w = "600"
          h = "400"
          if args.length >= 1
            url = args[0]
            if args.length == 3
              w = args[1]
              h = args[2]
            end
            html = "<iframe type=\"text/html\" width=\"".html_safe
            html << w
            html << "\" height=\"".html_safe
            html << h
            html << "\" src=\"".html_safe
            html << url
            html << "\" frameborder=\"0\"></iframe>".html_safe
            html
          else
            "<pre>Video macro error, check your syntax!</pre>".html_safe
          end
        end
      end
    end
  end
end


#module OpenProject
#  module WikiExtension
#    Redmine::WikiFormatting::Macros.register do
#      desc "Insert an iframe tag" + "\n\n" +
#	"  !{{iframe(url, width, height)}}" + "\n\n"
#      "  !{{iframe(url,  width, height, scroll)}}"
#      macro :iframe do |obj, args|
#	width = '100%'
#	width = args[1].strip if args[1]
#	height = '400pt'
#	height = args[2].strip if args[2]
#
#	scrolling = 'auto'
#	scrolling = args[3].strip if args.length > 3
#	url = /([a-zA-Z0-9]+:\/\/[-a-zA-Z0-9\.\?\&=\+@:_~\#\%\/\;]+)/.match(args[0]).to_a[1]
#	url = url.gsub(/\&#38;/,"&")
#	o = ''
#	o << '<iframe src="' + url + '" style="border: 0" width="' + width +
#	  '" height="' + height + '" frameborder="0" scrolling="' + scrolling + '"></iframe>'
#
#	return o.html_safe
#      end
#    end
#  end
#end

