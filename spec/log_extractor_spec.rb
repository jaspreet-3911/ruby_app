require_relative '../log_extractor'

describe LogExtractor do
  context 'validations' do
    it 'should throw FileError with invalid file' do
      expect { LogExtractor.run('abc.log') }
        .to raise_error(LogExtractor::FileError, 'File does not exist in the path { abc.log }')
    end

    it 'should throw FileError with empty file' do
      expect { LogExtractor.run('test.log') }
        .to raise_error(LogExtractor::FileError, 'File is empty!')
    end
  end

  context 'success' do
    it 'should display page views and unique views text' do
      out_str = <<~HEREDOC
                  **** List of webpages with most page views ordered from most pages views to less page views ****
                  /about/2 90 visits
                  /contact 89 visits
                  /index 82 visits
                  /about 81 visits
                  /help_page/1 80 visits
                  /home 78 visits
                  **** List of webpages with most unique page views also ordered ****
                  /index 23 unique views
                  /home 23 unique views
                  /contact 23 unique views
                  /help_page/1 23 unique views
                  /about/2 22 unique views
                  /about 21 unique views
                HEREDOC
      expect { LogExtractor.run('webserver.log')}
        .to output(out_str).to_stdout
    end
  end
end