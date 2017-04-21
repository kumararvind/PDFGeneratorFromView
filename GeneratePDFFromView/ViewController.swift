//
//  ViewController.swift
//  GeneratePDFFromView
//
//  Created by Infoicon on 21/04/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var viewInfoToGenPdf: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnGeneratePdfAction(_ sender: Any) {
        
          self.createPdfFromView(aView: viewInfoToGenPdf, saveToDocumentsWithFileName: self.getUniqueFileName(type: "pdf"))
    }
   
    func createPdfFromView(aView: UIView, saveToDocumentsWithFileName fileName: String)
    {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil)
        UIGraphicsBeginPDFPage()
        
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return }
        
        aView.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        
        let documentDirectory = self.getDocumentDirectoryPath()
        let documentsFileName = documentDirectory + "/" + fileName
    
         pdfData.write(toFile: documentsFileName, atomically: true)

    }
    
    func getFormattedDateString(date:Date,format:String)->String{
    
       let formatter         = DateFormatter()
        formatter.dateStyle  = .long
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    //MARK:=- File Manager

    func getUniqueFileName(type:String)->String{
    
        let dateString=self.getFormattedDateString(date: Date(), format: "ddMMyyyyHHmmss")
        let filaName="Pdf_"+dateString+"."+type
        
        return filaName
    }
    
    func getDocumentDirectoryPath()->String{
        
        let filemgr = FileManager.default
        
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        let docsURL = dirPaths[0]
        
        let newDir = docsURL.appendingPathComponent("mypdf").path
        
        if !filemgr.fileExists(atPath: newDir) {
           
            do {
                try filemgr.createDirectory(atPath: newDir,
                                            withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
    
        return newDir
    }
    
    func deleteADirectory(path:String){
    
         let filemgr = FileManager.default
        do {
            try filemgr.removeItem(atPath: path)
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func getFilesFromDocumentDirectory()->[String]{
    
         let filemgr = FileManager.default
        
        var arrayFilesName=[String]()
        do {
            let filelist = try filemgr.contentsOfDirectory(atPath: "/")
            
            for filename in filelist {
                print(filename)
                arrayFilesName.append(filename)
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        return arrayFilesName
    }
    
}

