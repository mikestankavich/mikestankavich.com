import { mdToPdf } from 'md-to-pdf';
import path from 'path';
import { readFile } from 'fs/promises';
import { existsSync } from 'fs';

const basePath = process.env.HOME ?
  path.join(process.env.HOME, 'mikestankavich.com') :
  path.resolve('./mikestankavich.com');

const basename = 'mike-stankavich-resume-pdo';
const style = path.join(basePath, 'resume', 'resume-style.css');
const input = path.join(basePath, 'resume', `${basename}.md`);
const output = path.join(basePath, 'public', `${basename}.pdf`);

// Verify paths and files
// console.log('Paths:', { basePath, style, input, output });
// console.log('Files exist:', {
//   styleExists: existsSync(style),
//   inputExists: existsSync(input),
//   outputDirExists: existsSync(path.join(basePath, 'public'))
// });

async function convertToPdf() {
  try {
    const css = await readFile(style, 'utf-8');

    const pdf = await mdToPdf(
      { path: input },
      {
        dest: output,
        css,
        launch_options: {
          executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
          args: ['--no-sandbox']
        },
        pdf_options: {
          format: 'Letter',
          margin: {
            top: '18mm',    
            right: '18mm',   
            bottom: '18mm',  
            left: '18mm'    
          },
          printBackground: true,
          scale: 1.0        // Ensure no scaling is applied
        },
        marked_options: {
          headerIds: false,
          mangle: false
        }
      }
    );

    if (pdf) {
      console.log('PDF generated successfully at:', output);
    }
  } catch (error) {
    console.error('Error generating PDF:', error);
    if (error.stack) {
      console.error('Stack trace:', error.stack);
    }
  }
}

convertToPdf();